{ lib
, stdenv
, audacious-plugins
, fetchurl
, gettext
, meson
, ninja
, pkg-config
, qtbase
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "audacious";
  version = "4.3.1";

  src = fetchurl {
    url = "http://distfiles.audacious-media-player.org/audacious-${version}.tar.bz2";
    sha256 = "sha256-heniaEFQW1HjQu5yotBfGb74lPVnoCnrs/Pgwa20IEI=";
  };

  nativeBuildInputs = [
    gettext
    meson
    ninja
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
  ];

  mesonFlags = [
    "-Dgtk=false"
    "-Dbuildstamp=NixOS"
  ];

  postInstall = lib.optionalString (audacious-plugins != null) ''
    ln -s ${audacious-plugins}/lib/audacious $out/lib
    ln -s ${audacious-plugins}/share/audacious/Skins $out/share/audacious/
  '';

  meta = with lib; {
    description = "A lightweight and versatile audio player";
    homepage = "https://audacious-media-player.org/";
    maintainers = with maintainers; [ eelco ramkromberg ttuegel thiagokokada ];
    platforms = with platforms; linux;
    license = with licenses; [
      bsd2
      bsd3 #https://github.com/audacious-media-player/audacious/blob/master/COPYING
      gpl2
      gpl3
      lgpl2Plus #http://redmine.audacious-media-player.org/issues/46
    ];
  };
}
