{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, glib, ncurses
, mpd_clientlib, gettext, boost }:

stdenv.mkDerivation rec {
  pname = "ncmpc";
  version = "0.35";

  src = fetchFromGitHub {
    owner  = "MusicPlayerDaemon";
    repo   = "ncmpc";
    rev    = "v${version}";
    sha256 = "0hhc5snxy5fbg47ynz4b7fkmzdy974zxqr0cqc6kh15yvbr25ikh";
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
