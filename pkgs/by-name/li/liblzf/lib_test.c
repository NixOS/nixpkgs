#include "lzf.h"
#include <stdio.h>
#include <string.h>

int main(void) {
  const char *test = "liblzf test for nixpkgs, nixpkgs for test liblzf";
  const size_t ilen = strlen(test) + 1;

  printf("Test string length: %zu\n", ilen);

  char compressed[100];
  char decompressed[100];

  unsigned int clen =
      lzf_compress(test, ilen, compressed, sizeof(compressed));
  if (!clen)
    return 1;

  printf("Compressed length: %d\n", clen);

  unsigned int dlen =
      lzf_decompress(compressed, clen, decompressed, sizeof(decompressed));
  if (!dlen)
    return 2;

  if (strcmp(test, decompressed) != 0) {
    printf("Strings don't match!\n");
    return 3;
  }

  printf("Strings match, tests passed!\n");
  return 0;
}
