{
  fetchzip,
  lib,
  stdenv,
  gmp,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "llr";
  version = "4.0.7b3";

  src = fetchzip {
    url = "http://jpenne.free.fr/llr4/llr${
      builtins.replaceStrings [ "." ] [ "" ] finalAttrs.version
    }src.zip";
    hash = "sha256-U6Mjpcq5Kdkx2f6tVQNBldsN4JiKXZqbil1Lg3Q5Asw=";
  };

  enableParallelBuilding = true;

  env.NIX_CFLAGS_COMPILE = "-std=gnu11";

  # Disable _chdir in lprime.c to prevent segmentation fault when fopen returns NULL
  postPatch = ''
    substituteInPlace lprime.c \
      --replace-fail "_chdir (buf)" "0/* _chdir (buf) */"
  '';

  buildPhase = ''
    runHook preBuild

    make -f make64

    cd linux64llr

    make llr64 \
      LFLAGS="-L${gmp}/lib -lgmp -lm -lpthread"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 llr64 $out/bin/llr

    runHook postInstall
  '';

  meta = {
    description = "Primality proving program for numbers of the form N = k*b^n +/- 1, (k < b^n)";
    homepage = "http://jpenne.free.fr/index2.html";
    maintainers = with lib.maintainers; [ dstremur ];
    license = lib.licenses.unfree;
    # LLR links against gwnum.a which is part of the proprietary gwnum library,
    # making the resulting binary unfree even though the LLR source code itself
    # may have different licensing terms.
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "llr";
  };
})
