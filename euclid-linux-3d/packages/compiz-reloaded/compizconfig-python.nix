{ lib, stdenv, fetchurl, pkg-config, intltool, autoconf, automake, libtool, compiz-core, libcompizconfig, glib, libxml2, pcre, pciutils, python3, python3Packages, xorg, libstartup_notification, cairo, libjpeg, libpng, libGL, libGLU, which }:

stdenv.mkDerivation rec {
  pname = "compizconfig-python";
  version = "0.8.18";

  src = fetchurl {
    url = "https://gitlab.com/compiz/compizconfig-python/-/archive/v0.8.18/compizconfig-python-v0.8.18.tar.gz";
    hash = "sha256-QkO5WDniXlrcwUbSJ7ZlyW2sLi4Ik8zMAhXJpn7DO2c=";
  };

  nativeBuildInputs = [ pkg-config intltool autoconf automake libtool python3 python3Packages.cython python3Packages.setuptools which ];

  buildInputs = [
    xorg.libX11 xorg.libXcomposite xorg.libXdamage xorg.libXfixes xorg.libXrandr xorg.libXinerama xorg.libSM xorg.libICE xorg.libXext xorg.libXi xorg.libXcursor xorg.libxcb xorg.xcbutil libstartup_notification cairo libjpeg libpng libGL libGLU
    compiz-core libcompizconfig glib libxml2 pcre pciutils python3
  ];

  preConfigure = ''
    NOCONFIGURE=1 ./autogen.sh
    export PATH=${python3Packages.cython}/bin:$PATH
  '';

  configureFlags = [ "CYTHON=${python3Packages.cython}/bin/cython" ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration -Wno-error=incompatible-pointer-types -Wno-error=builtin-declaration-mismatch -Wno-error=implicit-int";
  env.CFLAGS = "-include stdlib.h";

  doCheck = false;

  meta = {
    description = "Compiz Config Python Bindings";
    homepage = "https://gitlab.com/compiz/compizconfig-python";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
