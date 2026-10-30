#include <Inventor/C/glue/dl.h>
#include <stdio.h>

int main(void)
{
  const struct {
    const char *name;
    const char *symbol;
  } libraries[] = {
    { "libbz2.so", "BZ2_bzlibVersion" },
    { "libfontconfig.so", "FcInit" },
    { "libfreetype.so", "FT_Init_FreeType" },
    { "libGLU.so", "gluNewTess" },
    { "libopenal.so", "alGetString" },
    { "libz.so", "zlibVersion" },
  };

  for (size_t i = 0; i < sizeof(libraries) / sizeof(libraries[0]); ++i) {
    cc_libhandle handle = cc_dl_open(libraries[i].name);
    if (handle == NULL) {
      fprintf(stderr, "Coin could not load %s\n", libraries[i].name);
      return 1;
    }
    if (cc_dl_sym(handle, libraries[i].symbol) == NULL) {
      fprintf(stderr, "%s does not provide %s\n",
              libraries[i].name, libraries[i].symbol);
      return 1;
    }
    cc_dl_close(handle);
  }

  return 0;
}
