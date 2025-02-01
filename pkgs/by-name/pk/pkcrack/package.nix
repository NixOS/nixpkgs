{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pkcrack";
  version = "1.2.2";

  src = fetchurl {
    url = "https://www.unix-ag.uni-kl.de/~conrad/krypto/pkcrack/pkcrack-${finalAttrs.version}.tar.gz";
    hash = "sha256-TS3Bk/+kNCrC7TpjEf33cK5qB3Eiaz70U9yo0D5DiVo=";
  };
  sourceRoot = "pkcrack-${finalAttrs.version}/src";

  postPatch = ''
    # malloc.h is not needed because stdlib.h is already included.
    # On macOS, malloc.h does not even exist, resulting in an error.
    substituteInPlace exfunc.c extract.c main.c readhead.c zipdecrypt.c \
      --replace '#include <malloc.h>' ""
  '';

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];
  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    install -D extract $out/bin/extract
    install -D findkey $out/bin/findkey
    install -D makekey $out/bin/makekey
    install -D pkcrack $out/bin/pkcrack
    install -D zipdecrypt $out/bin/zipdecrypt

    mkdir -p $out/share/doc
    cp -R ../doc/ $out/share/doc/pkcrack

    runHook postInstall
  '';

  meta = with lib; {
    description = "Breaking PkZip-encryption";
    homepage = "https://www.unix-ag.uni-kl.de/~conrad/krypto/pkcrack.html";
    license = {
      fullName = "PkCrack Non Commercial License";
      url = "https://www.unix-ag.uni-kl.de/~conrad/krypto/pkcrack/pkcrack-readme.html";
      free = false;
    };
    maintainers = with maintainers; [ emilytrau ];
    platforms = platforms.all;
    mainProgram = "pkcrack";
  };
})
