CFLAGS=-O2 -fPIC -Wall -Wextra

all: bin/tete lib/libtete.so
bin/tete: test.o a.o -ldl
lib/libtete.so: a.o

###################################
# don't change stuff beneath here #
###################################

ifndef SRCDIR
SRCDIR=src
endif
ifndef BINDIR
BINDIR=bin
endif
ifndef LIBDIR
LIBDIR=lib
endif
ifndef DEPDIR
DEPDIR=.dep
endif
ifndef OBJDIR
OBJDIR=.obj
endif

clean:
	@rm -fr $(DEPDIR) $(OBJDIR) $(BINDIR) $(LIBDIR)

$(BINDIR)/%:
	@mkdir -p $(BINDIR)
	$(CC) -o $@ $(CFLAGS) $(patsubst %.o,$(OBJDIR)/%.o,$^)

$(LIBDIR)/%:
	@mkdir -p $(LIBDIR)
	$(CC) -o $@ $(CFLAGS) -g -shared $(patsubst %.o,$(OBJDIR)/%.o,$^)

%.o: $(OBJDIR)/%.o
	@echo -n

.SECONDARY:

$(OBJDIR)/%.o: $(SRCDIR)/%.c $(DEPDIR)/%.dep
	@mkdir -p $(OBJDIR)
	$(CC) -o $@ $(CFLAGS) -c $<

$(DEPDIR)/%.dep: $(SRCDIR)/%.c
	@mkdir -p $(DEPDIR)
	@$(CC) -M -MM -MT $(patsubst $(SRCDIR)/%.c,$(OBJDIR)/%.o,$<) -o $@ $<

-include $(wildcard $(DEPDIR)/*.dep)
