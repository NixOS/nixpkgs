{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, glib, ncurses
, mpd_clientlib, gettext }:

stdenv.mkDerivation rec {
  name = "ncmpc-${version}";
  version = "0.31";

  src = fetchFromGitHub {
    owner  = "MusicPlayerDaemon";
    repo   = "ncmpc";
    rev    = "v${version}";
    sha256 = "09h1m9rkk89729i2d5zsfdc6rxajvikgsi3h99rwz2192gm457rj";
  };

  buildInputs = [ glib ncurses mpd_clientlib ];
  nativeBuildInputs = [ meson ninja pkgconfig gettext ];

  meta = with stdenv.lib; {
    description = "Curses-based interface for MPD (music player daemon)";
    homepage    = https://www.musicpd.org/clients/ncmpc/;
    license     = licenses.gpl2Plus;
    platforms   = platforms.all;
    maintainers = with maintainers; [ fpletz ];
  };
}
