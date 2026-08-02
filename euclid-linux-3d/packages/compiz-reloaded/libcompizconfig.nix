{ lib, stdenv, fetchurl, pkg-config, intltool, autoconf, automake, libtool, compiz-core, glib, libxml2, pcre, pciutils, protobuf, xorg, libstartup_notification, cairo, libjpeg, libpng, libGL, libGLU }:

stdenv.mkDerivation rec {
  pname = "libcompizconfig";
  version = "0.8.18";

  src = fetchurl {
    url = "https://gitlab.com/compiz/libcompizconfig/-/archive/v0.8.18/libcompizconfig-v0.8.18.tar.gz";
    hash = "sha256-nvpMdfr8bqQ1UMNTxlR+x3uqRSjRx32x1tnd6hl6A38=";
  };

  nativeBuildInputs = [ pkg-config intltool autoconf automake libtool ];

  buildInputs = [
    compiz-core glib libxml2 pcre pciutils protobuf
    xorg.libX11 xorg.libXcomposite xorg.libXdamage xorg.libXfixes xorg.libXrandr xorg.libXinerama
    xorg.libSM xorg.libICE xorg.libXext xorg.libXi xorg.libXcursor xorg.libxcb xorg.xcbutil
    libstartup_notification cairo libjpeg libpng libGL libGLU
  ];

  preConfigure = ''
    NOCONFIGURE=1 ./autogen.sh
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration -Wno-error=incompatible-pointer-types -Wno-error=builtin-declaration-mismatch -Wno-error=implicit-int";
  env.CFLAGS = "-include stdlib.h";

  doCheck = false;

  meta = {
    description = "Compiz Config Library";
    homepage = "https://gitlab.com/compiz/libcompizconfig";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
