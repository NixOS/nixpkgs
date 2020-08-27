{ stdenv, fetchFromGitHub, meson, ninja, pkgconfig, glib, ncurses
, mpd_clientlib, gettext, boost
, pcreSupport ? false
, pcre ? null
}:

with stdenv.lib;

assert pcreSupport -> pcre != null;

stdenv.mkDerivation rec {
  pname = "ncmpc";
  version = "0.39";

  src = fetchFromGitHub {
    owner  = "MusicPlayerDaemon";
    repo   = "ncmpc";
    rev    = "v${version}";
    sha256 = "08xrcinfm1a7hjycf8la7gnsxbp3six70ks987dr7j42kd42irfq";
  };

  buildInputs = [ glib ncurses mpd_clientlib boost ]
    ++ optional pcreSupport pcre;
  nativeBuildInputs = [ meson ninja pkgconfig gettext ];

  mesonFlags = [
    "-Dlirc=disabled"
    "-Ddocumentation=disabled"
  ] ++ optional (!pcreSupport) "-Dregex=disabled";

  meta = with stdenv.lib; {
    description = "Curses-based interface for MPD (music player daemon)";
    homepage    = "https://www.musicpd.org/clients/ncmpc/";
    license     = licenses.gpl2Plus;
    platforms   = platforms.all;
    maintainers = with maintainers; [ fpletz ];
  };
}
