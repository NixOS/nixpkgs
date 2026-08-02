{ lib, stdenv, fetchurl, pkg-config, intltool, autoconf, automake, libtool, compiz-bcop, compiz-core, glib, libxml2, pcre, pciutils, xorg, libstartup_notification, cairo, libjpeg, libpng, libGL, libGLU, gettext }:

stdenv.mkDerivation rec {
  pname = "compiz-plugins-main";
  version = "0.8.18";

  src = fetchurl {
    url = "https://gitlab.com/compiz/compiz-plugins-main/-/archive/v0.8.18/compiz-plugins-main-v0.8.18.tar.gz";
    hash = "sha256-Uad6oQE6YK/6ntvSE2Z2ED1mTsFdDdYRLnBuSwOz+hI=";
  };

  nativeBuildInputs = [ pkg-config intltool autoconf automake libtool gettext compiz-bcop ];

  buildInputs = [
    compiz-core glib libxml2 pcre pciutils
    xorg.libX11 xorg.libXcomposite xorg.libXdamage xorg.libXfixes xorg.libXrandr xorg.libXinerama
    xorg.libSM xorg.libICE xorg.libXext xorg.libXi xorg.libXcursor xorg.libxcb xorg.xcbutil
    libstartup_notification cairo libjpeg libpng libGL libGLU
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
    description = "Compiz Main Plugins";
    homepage = "https://gitlab.com/compiz/compiz-plugins-main";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
