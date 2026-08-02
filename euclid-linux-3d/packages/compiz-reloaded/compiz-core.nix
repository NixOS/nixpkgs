{ lib, stdenv, fetchurl, pkg-config, intltool, autoconf, automake, libtool, xorg, libstartup_notification, glib, libxml2, pcre, libxslt, pciutils, gettext, makeWrapper, libpng, libGL, libjpeg, libGLU, cairo }:

stdenv.mkDerivation rec {
  pname = "compiz-core";
  version = "0.8.18";

  src = fetchurl {
    url = "https://gitlab.com/compiz/compiz-core/-/archive/v0.8.18/compiz-core-v0.8.18.tar.gz";
    hash = "sha256-cWjsqEsYMsU85YCMAAmefu4wQwN7hYsDuCxsjY4tSFI=";
  };

  nativeBuildInputs = [ pkg-config intltool autoconf automake libtool makeWrapper gettext ];

  buildInputs = [
    xorg.libX11 xorg.libXcomposite xorg.libXdamage xorg.libXfixes
    xorg.libXrandr xorg.libXinerama xorg.libSM xorg.libICE xorg.libXext xorg.libXi xorg.libXcursor xorg.libxcb xorg.xcbutil
    libstartup_notification glib libxml2 pcre
    libxslt pciutils libpng libGL libjpeg libGLU cairo
  ];

  preConfigure = ''
    export GTK_UPDATE_ICON_CACHE=true
    export UPDATE_ICON_CACHE=true
    NOCONFIGURE=1 ./autogen.sh
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration -Wno-error=incompatible-pointer-types -Wno-error=builtin-declaration-mismatch -Wno-error=implicit-int";
  env.CFLAGS = "-include stdlib.h";

  makeFlags = [ "UPDATE_ICON_CACHE=true" ];

  doCheck = false;

  meta = {
    description = "Compiz Core";
    homepage = "https://gitlab.com/compiz/compiz-core";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
