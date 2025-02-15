#include <elf.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef enum {
  ShouldRunPatchelf_Yes = 0,
  ShouldRunPatchelf_No,
} ShouldRunPatchelf_t;

ShouldRunPatchelf_t check_elf_type_32(FILE *file, int is_little_endian)
{
  Elf32_Ehdr elf_header;

  // Read the ELF header
  fseek(file, 0, SEEK_SET);
  if (fread(&elf_header, 1, sizeof(Elf32_Ehdr), file) != sizeof(Elf32_Ehdr)) {
    perror("Failed to read ELF header (32-bit)");
    return ShouldRunPatchelf_No;
  }

  // Adjust for endianness if needed
  if (!is_little_endian) {
    elf_header.e_type = __builtin_bswap16(elf_header.e_type);
  }

  // Check the type
  switch (elf_header.e_type) {
    case ET_EXEC:
    case ET_DYN:
      return ShouldRunPatchelf_Yes;
    default:
      return ShouldRunPatchelf_No;
  }
}

ShouldRunPatchelf_t check_elf_type_64(FILE *file, int is_little_endian)
{
  Elf64_Ehdr elf_header;

  // Read the ELF header
  fseek(file, 0, SEEK_SET);
  if (fread(&elf_header, 1, sizeof(Elf64_Ehdr), file) != sizeof(Elf64_Ehdr)) {
    perror("Failed to read ELF header (64-bit)");
    return ShouldRunPatchelf_No;
  }

  // Adjust for endianness if needed
  if (!is_little_endian) {
    elf_header.e_type = __builtin_bswap16(elf_header.e_type);
  }

  // Check the type
  switch (elf_header.e_type) {
    case ET_EXEC:
    case ET_DYN:
      return ShouldRunPatchelf_Yes;
    default:
      return ShouldRunPatchelf_No;
  }
}

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

  // Read the ELF identification
  unsigned char e_ident[EI_NIDENT];
  if (fread(e_ident, 1, EI_NIDENT, file) != EI_NIDENT) {
    return EXIT_FAILURE;
  }

  // Check the ELF magic number
  if (memcmp(e_ident, ELFMAG, SELFMAG) != 0) {
    fclose(file);
    return EXIT_FAILURE;
  }

  // Determine the ELF class (32-bit or 64-bit)
  int is_64_bit = (e_ident[EI_CLASS] == ELFCLASS64);
  int is_32_bit = (e_ident[EI_CLASS] == ELFCLASS32);
  int is_little_endian = (e_ident[EI_DATA] == ELFDATA2LSB);

  if (is_64_bit) {
    return check_elf_type_64(file, is_little_endian) == ShouldRunPatchelf_Yes ? EXIT_SUCCESS : EXIT_FAILURE;
  } else if (is_32_bit) {
    return check_elf_type_32(file, is_little_endian) == ShouldRunPatchelf_Yes ? EXIT_SUCCESS : EXIT_FAILURE;
  } else {
    printf("Unknown ELF class.\n");
    return EXIT_FAILURE;
  }
}
