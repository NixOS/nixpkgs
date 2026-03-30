CFLAGS ?= -Os

all: redo links

links:
	sh links.do

install:
	mkdir -p "$(out)/bin"
	cp --no-dereference redo redo-* "$(out)/bin"
