#include <elf.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv)
{
  if (argc != 2) {
    fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
    return EXIT_FAILURE;
  }

  FILE *file = fopen(argv[1], "rb");
  if (!file) {
    perror("Failed to open file");
    return EXIT_FAILURE;
  }

  // Read ELF magic ID
  char magic[sizeof ELFMAG] = {0};
  // -1 for null terminator
  fread(magic, 1, sizeof magic - 1, file);
  // Ensure null termination
  magic[sizeof magic - 1] = '\0';

  return strcmp(magic, ELFMAG) ? EXIT_FAILURE : EXIT_SUCCESS;
}
