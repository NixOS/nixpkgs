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
  version = "4.3";

  src = fetchurl {
    url = "http://distfiles.audacious-media-player.org/audacious-${version}.tar.bz2";
    sha256 = "sha256-J1hNyEXH5w24ySZ5kJRfFzIqHsyA/4tFLpypFqDOkJE=";
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
