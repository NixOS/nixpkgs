{ stdenv, fetchurl, pkgconfig, gtk2, xorg, glib, xneur_0_13, libglade, GConf, pcre }:

stdenv.mkDerivation {
  name = "gxneur-0.13.0";
  
  src = fetchurl {
    url = http://dists.xneur.ru/release-0.13.0/tgz/gxneur-0.13.0.tar.bz2;
    sha256 = "f093428a479158247a7ff8424f0aec9af9f7b1d05b191cf30b7c534965a6839f";
  };

  buildInputs = [
    xorg.libX11 pkgconfig  glib gtk2 xorg.libXpm xorg.libXt xorg.libXext xneur_0_13
    libglade GConf pcre
  ];

  preConfigure = ''
    sed -e 's@-Werror@@' -i configure
    sed -e 's@"xneur"@"${xneur_0_13}/bin/xneur"@' -i src/misc.c
  '';

  meta = {
    description = "GUI for XNEUR keyboard layout switcher";
    platforms = stdenv.lib.platforms.linux;
  };
}
