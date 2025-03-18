#include <assert.h>
#include <limits.h>
#include <stdio.h>
#include <string.h>

FILE *fopen_wrapped(const char *restrict path,
                    const char *restrict const mode) {
  static const char ORIGINAL_DIR[] = "/usr/local/Brother/sane/";
  static const char REAL_DIR[] = OUT "/local/Brother/sane/";
  char buffer[PATH_MAX];

  if (strstr(path, ORIGINAL_DIR) == path) {
    const char *const relpath = path + sizeof ORIGINAL_DIR - 1;
    const size_t relpath_size = strlen(relpath) + 1;
    assert(sizeof REAL_DIR - 1 + relpath_size < PATH_MAX);

    memcpy(buffer, REAL_DIR, sizeof REAL_DIR - 1);
    memcpy(buffer + sizeof REAL_DIR - 1, relpath, relpath_size);

    path = buffer;
  }

  return fopen(path, mode);
}
