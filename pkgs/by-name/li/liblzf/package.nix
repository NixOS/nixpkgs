{
  lib,
  fetchurl,
  stdenv,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "liblzf";
  version = "3.6";

  # used for changelog and test file
  cvsTag = "rel-${builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version}";

  src = fetchurl {
    url = "http://dist.schmorp.de/liblzf/liblzf-${finalAttrs.version}.tar.gz";
    hash = "sha256-nF3gH3ucyuQMP2GdJqer7JmGwGw20mDBec7dBLiftGo=";
  };

  doCheck = true;

  preCheck = ''
    cat > test.c <<'EOF'
    #include <stdio.h>
    #include <string.h>
    #include "lzf.h"

    int main(void) {
        const char *test = "liblzf test for nixpkgs";
        char compressed[100];
        char decompressed[100];

        unsigned int clen = lzf_compress(test, strlen(test), compressed, sizeof(compressed));
        if (!clen) return 1;

        unsigned int dlen = lzf_decompress(compressed, clen, decompressed, sizeof(decompressed));
        if (!dlen) return 2;

        decompressed[dlen] = '\0';
        return strcmp(test, decompressed) != 0;
    }
    EOF
  '';

  checkPhase = ''
    runHook preCheck

    $CC $CFLAGS -g test.c -o test -L. -llzf -Wl,-rpath,$PWD

    ./test

    runHook postCheck
  '';

  meta = {
    homepage = "http://software.schmorp.de/pkg/liblzf.html";
    description = "LibLZF is a very small data compression library.";
    changelog = "http://cvs.schmorp.de/liblzf/Changes?pathrev=rel-$finalAttrs.cvsTag}";
    license = with lib.licenses; [
      bsd2
      gpl2Plus
    ];
    maintainers = with lib.maintainers; [
      tetov
    ];
    platforms = lib.platforms.unix;
  };
})
