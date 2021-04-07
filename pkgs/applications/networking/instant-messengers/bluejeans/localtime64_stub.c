#include <stdio.h>
#include <stdlib.h>

void *localtime64() {
  fprintf(stderr, "nixpkgs: call into localtime64_r\n");
  abort();
}

void *localtime64_r() {
  fprintf(stderr, "nixpkgs: call into localtime64_r\n");
  abort();
}
