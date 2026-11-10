PREFIX = $(out)
BINDIR = $(PREFIX)/bin
LIBEXECDIR = $(PREFIX)/libexec
LIBDIR = $(PREFIX)/lib
TYPELIBDIR = $(LIBDIR)/girepository-1.0

all:
	echo "Compiling…"
install:
	echo "Installing…"

bin:
	mkdir -p $(BINDIR)
# Adds `bin-${foo}` targets, that install `${foo}` executable to `$(BINDIR)`.
bin-%: bin
	touch $(BINDIR)/$(@:bin-%=%)
	chmod +x $(BINDIR)/$(@:bin-%=%)

libexec:
	mkdir -p $(LIBEXECDIR)
# Adds `libexec-${foo}` targets, that install `${foo}` executable to `$(LIBEXECDIR)`.
libexec-%: libexec
	touch $(LIBEXECDIR)/$(@:libexec-%=%)
	chmod +x $(LIBEXECDIR)/$(@:libexec-%=%)

typelib:
	mkdir -p $(TYPELIBDIR)
# Adds `typelib-${foo}` targets, that install `${foo}-1.0.typelib` file to `$(TYPELIBDIR)`.
typelib-%: typelib
	touch $(TYPELIBDIR)/$(@:typelib-%=%)-1.0.typelib
