{
  lib,
  stdenv,
  fetchurl,

  libX11,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "3dpong";
  version = "0.5";

  src = fetchurl {
    url = "https://tuxpaint.org/ftp/unix/x/3dpong/src/3dpong-${finalAttrs.version}.tar.gz";
    hash = "sha256-sVV4GDGfSCweB5UZLwE+z5mMnxATAztUJnbRv3Q6a8U=";
  };

  postPatch = ''
    substituteInPlace src/3dpong.c --replace-fail \
      "#include <stdio.h>" \
      "#include <stdio.h>
       #include <unistd.h>"

    substituteInPlace src/randnum.c --replace-fail \
      "#include <stdio.h>" \
      "#include <stdio.h>
       #include <stdlib.h>"

    substituteInPlace src/text.c --replace-fail \
      "#include <X11/Xlib.h>" \
      "#include <X11/Xlib.h>
       #include <string.h>"
  '';

  buildInputs = [ libX11 ];

  makeFlags = [
    "PREFIX=$(out)"
    "CC=${stdenv.cc.targetPrefix}cc" # fix darwin and cross-compiled builds
  ];

  meta = {
    homepage = "http://www.newbreedsoftware.com/3dpong/";
    description = "One or two player 3d sports game based on Pong from Atari";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})
