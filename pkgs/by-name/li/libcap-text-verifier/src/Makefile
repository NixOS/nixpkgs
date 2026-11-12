.PHONY: all check install

LDFLAGS = -lcap

all: libcap-text-verifier

libcap-text-verifier: main.c
	$(CC) $(CFLAGS) -Wall -Wextra -Werror -o $@ $< $(LDFLAGS)

install: libcap-text-verifier
	install -Dm755 $< $(out)/bin/$<

check: libcap-text-verifier
	./$< "cap_setuid+ep" # should succeed
	! ./$< "x=y" # should fail
