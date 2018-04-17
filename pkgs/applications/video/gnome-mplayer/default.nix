{stdenv, substituteAll, fetchFromGitHub, pkgconfig, gettext, glib, gtk3, gmtk, dbus, dbus-glib
, libnotify, libpulseaudio, mplayer, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "gnome-mplayer-${version}";
  version = "1.0.9";

  src = fetchFromGitHub {
    owner = "kdekorte";
    repo = "gnome-mplayer";
    rev = "v${version}";
    sha256 = "0qvy9fllvg1mad6y1j79iaqa6khs0q2cb0z62yfg4srbr07fi8xr";
  };

  nativeBuildInputs = [ pkgconfig gettext wrapGAppsHook ];
  buildInputs = [ glib gtk3 gmtk dbus dbus-glib libnotify libpulseaudio ];

  patches = [
    (substituteAll {
      src = ./fix-paths.patch;
      mencoder = "${mplayer}/bin/mencoder";
      mplayer = "${mplayer}/bin/mplayer";
    })
  ];

  meta = with stdenv.lib; {
    description = "Gnome MPlayer, a simple GUI for MPlayer";
    homepage = https://sites.google.com/site/kdekorte2/gnomemplayer;
    license = licenses.gpl2;
    maintainers = with maintainers; [];
    platforms = platforms.linux;
  };
}
