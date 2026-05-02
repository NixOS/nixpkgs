.PHONY: all install

LDFLAGS = -lcap

all: libcap-text-verifier

libcap-text-verifier: main.c
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

install: libcap-text-verifier
	install -Dm755 $< $(out)/bin/$<
