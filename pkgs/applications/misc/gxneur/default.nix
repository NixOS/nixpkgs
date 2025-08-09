{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  intltool,
  gtk2,
  xorg,
  glib,
  xneur,
  libglade,
  GConf,
  libappindicator-gtk2,
  pcre,
}:

stdenv.mkDerivation rec {
  pname = "gxneur";
  version = "0.20.0";

  src = fetchurl {
    url = "https://github.com/AndrewCrewKuznetsov/xneur-devel/raw/f66723feb272c68f7c22a8bf0dbcafa5e3a8a5ee/dists/${version}/gxneur_${version}.orig.tar.gz";
    sha256 = "0avmhdcj0hpr55fc0iih8fjykmdhn34c8mwdnqvl8jh4nhxxchxr";
  };

  # glib-2.62 deprecations
  env.NIX_CFLAGS_COMPILE = "-DGLIB_DISABLE_DEPRECATION_WARNINGS";

  nativeBuildInputs = [
    pkg-config
    intltool
  ];
  buildInputs = [
    xorg.libX11
    glib
    gtk2
    xorg.libXpm
    xorg.libXt
    xorg.libXext
    xneur
    libglade
    GConf
    pcre
    libappindicator-gtk2
  ];

  meta = with lib; {
    description = "GUI for XNEUR keyboard layout switcher";
    platforms = platforms.linux;
    license = with licenses; [
      gpl2
      gpl3
    ];
    mainProgram = "gxneur";
  };
}
