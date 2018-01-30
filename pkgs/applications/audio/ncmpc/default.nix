{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, glib, ncurses
, mpd_clientlib, gettext }:

stdenv.mkDerivation rec {
  name = "ncmpc-${version}";
  version = "0.29";

  src = fetchFromGitHub {
    owner  = "MusicPlayerDaemon";
    repo   = "ncmpc";
    rev    = "v${version}";
    sha256 = "1b2kbx2phbf4s2qpy7mx72c87xranljr0yam6z9m1i1kvcnp8q1q";
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
