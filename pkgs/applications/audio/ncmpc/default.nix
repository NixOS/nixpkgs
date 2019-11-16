{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, glib, ncurses
, mpd_clientlib, gettext, boost }:

stdenv.mkDerivation rec {
  pname = "ncmpc";
  version = "0.36";

  src = fetchFromGitHub {
    owner  = "MusicPlayerDaemon";
    repo   = "ncmpc";
    rev    = "v${version}";
    sha256 = "1ssmk1p43gjhcqi86sh6b7csqpwwpf3hs32cmnylv6pmbcwbs69h";
  };

  buildInputs = [ glib ncurses mpd_clientlib boost ];
  nativeBuildInputs = [ meson ninja pkgconfig gettext ];

  mesonFlags = [
    "-Dlirc=disabled"
    "-Dregex=disabled"
    "-Ddocumentation=disabled"
  ];

  meta = with stdenv.lib; {
    description = "Curses-based interface for MPD (music player daemon)";
    homepage    = https://www.musicpd.org/clients/ncmpc/;
    license     = licenses.gpl2Plus;
    platforms   = platforms.all;
    maintainers = with maintainers; [ fpletz ];
  };
}
