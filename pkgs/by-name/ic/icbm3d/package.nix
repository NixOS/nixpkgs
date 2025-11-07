{
  lib,
  stdenv,
  fetchurl,
  libX11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "icbm3d";
  version = "0.4";

  src = fetchurl {
    url = "ftp://ftp.tuxpaint.org/unix/x/icbm3d/icbm3d.${finalAttrs.version}.tar.gz";
    hash = "sha256-mtQcFU70dpV3GiaHXVQVvO3LE5NSseIXXzhtIGsAOP0=";
  };

  buildInputs = [ libX11 ];

  buildFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ]; # fix darwin and cross-compiled builds

  # Function are declared after they are used in the file, this is error since gcc-14.
  #   randnum.c:25:3: warning: implicit declaration of function 'srand' [-Wimplicit-function-declaration]
  #   randnum.c:33:7: warning: implicit declaration of function 'rand'; did you mean 'randnum'? [-Wimplicit-function-declaration]
  #   text.c:34:50: warning: implicit declaration of function 'strlen' [-Wimplicit-function-declaration]
  postPatch = ''
    substituteInPlace randnum.c --replace-fail 'stdio.h' 'stdlib.h'
    sed -i '1i\
    #include <string.h>' text.c

    # The Makefile tries to install icbm3d immediately after building it, and
    # ends up trying to copy it to /icbm3d. Normally this just gets an error
    # and moves on, but it's probably better to not try it in the first place.
    sed -i '/INSTALLROOT/d' makefile
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 -t $out/bin icbm3d

    runHook postInstall
  '';

  meta = {
    homepage = "http://www.newbreedsoftware.com/icbm3d/";
    description = "3D vector-based clone of the atari game Missile Command";
    mainProgram = "icbm3d";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
