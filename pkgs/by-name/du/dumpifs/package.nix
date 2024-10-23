{
  clang,
  fetchFromGitHub,
  lib,
  lzo,
  lz4,
  stdenv,
  ucl,
  unstableGitUpdater,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dumpifs";
  version = "0-unstable-2020-05-07";

  src = fetchFromGitHub {
    owner = "askac";
    repo = "dumpifs";
    rev = "b7bac90e8312eca2796f2003a52791899eb8dcd9";
    hash = "sha256-vFiMKcPfowLQQZXlXbq5ZR1X6zr7u3iQwz3o4A6aQMY=";
  };

  buildInputs = [
    clang
    lzo
    lz4
    ucl
    zlib
  ];

  postUnpack = ''
    rm source/{dumpifs,exMifsLzo,uuu,zzz}
  '';

  preBuild = ''
    #FIX LINUX BUILD ERRORS
    sed -i '10i #include <string.h>' fixdecifs.c
    sed -i '6i #include <string.h>' fixencifs.c
    sed -i '/error(1/{N; d;}' exMifsLzo.c
    sed -i '76i fprintf(stderr, "decompression init failure"); exit(1);' exMifsLzo.c

    #FIX MAC BUILD ERRORS
    sed -i '/#include <error.h>/d' uuu.c
    sed -i '9i #include <stdlib.h>' uuu.c
    sed -i '/error(1/{N; d;}' uuu.c
    sed -i '41i fprintf(stderr, "compression failure.\\n"); exit(1);' uuu.c

    sed -i '/#include <error.h>/d' zzz.c
    sed -i '9i #include <stdlib.h>' zzz.c
    sed -i '/error(1/{N; d;}' zzz.c
    sed -i '43i fprintf(stderr, "compression failure.\\n"); exit(1);' zzz.c
  '';

  installPhase = ''
    install -D dumpifs exMifsLz4 exMifsLzo fixdecifs fixencifs uuu zzz -t $out/bin
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Tool for those who are interested in hacking MIB2 firmware";
    homepage = "https://github.com/askac/dumpifs";
    platforms = lib.platforms.unix;
    mainProgram = "dumpifs";
  };
})
