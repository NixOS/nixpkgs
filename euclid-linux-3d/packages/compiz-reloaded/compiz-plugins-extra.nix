{ lib, stdenv, fetchurl, pkg-config, intltool, autoconf, automake, libtool, compiz-bcop, compiz-core, compiz-plugins-main, glib, libxml2, pcre, pciutils, xorg, libstartup_notification, cairo, libjpeg, libpng, libGL, libGLU, gettext }:

stdenv.mkDerivation rec {
  pname = "compiz-plugins-extra";
  version = "0.8.18";

  src = fetchurl {
    url = "https://gitlab.com/compiz/compiz-plugins-extra/-/archive/v0.8.18/compiz-plugins-extra-v0.8.18.tar.gz";
    hash = "sha256-HMWV9PO9JwPOKMdHIPou2ElOzmARez4yQwqbv2vBQYQ=";
  };

  nativeBuildInputs = [ pkg-config intltool autoconf automake libtool gettext compiz-bcop ];

  buildInputs = [
    compiz-core compiz-plugins-main glib libxml2 pcre pciutils
    xorg.libX11 xorg.libXcomposite xorg.libXdamage xorg.libXfixes xorg.libXrandr xorg.libXinerama
    xorg.libSM xorg.libICE xorg.libXext xorg.libXi xorg.libXcursor xorg.libxcb xorg.xcbutil
    libstartup_notification cairo libjpeg libpng libGL libGLU
  ];

  preConfigure = ''
    export GTK_UPDATE_ICON_CACHE=true
    export UPDATE_ICON_CACHE=true
    NOCONFIGURE=1 ./autogen.sh
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration -Wno-error=incompatible-pointer-types -Wno-error=builtin-declaration-mismatch -Wno-error=implicit-int -I${compiz-plugins-main}/include/compiz";
  env.CFLAGS = "-include stdlib.h -D_GNU_SOURCE -D_LARGEFILE64_SOURCE";

  makeFlags = [ "UPDATE_ICON_CACHE=true" ];
  doCheck = false;

  meta = {
    description = "Compiz Extra Plugins";
    homepage = "https://gitlab.com/compiz/compiz-plugins-extra";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
