{ stdenv, fetchurl, pkgconfig, intltool, gtk2, xorg, glib, xneur, libglade, GConf, libappindicator-gtk2, pcre }:

stdenv.mkDerivation {
  name = "gxneur-0.20.0";

  src = fetchurl {
    url = https://github.com/AndrewCrewKuznetsov/xneur-devel/raw/f66723feb272c68f7c22a8bf0dbcafa5e3a8a5ee/dists/0.20.0/gxneur_0.20.0.orig.tar.gz;
    sha256 = "0avmhdcj0hpr55fc0iih8fjykmdhn34c8mwdnqvl8jh4nhxxchxr";
  };

  NIX_CFLAGS_COMPILE = "-Wno-deprecated-declarations";

  nativeBuildInputs = [ pkgconfig intltool ];
  buildInputs = [
    xorg.libX11 glib gtk2 xorg.libXpm xorg.libXt xorg.libXext xneur
    libglade GConf pcre libappindicator-gtk2
  ];

  meta = with stdenv.lib; {
    description = "GUI for XNEUR keyboard layout switcher";
    platforms = platforms.linux;
    license = with licenses; [ gpl2 gpl3 ];
  };
}
