{ lib, stdenv, fetchFromGitHub, meson, ninja, pkg-config, glib, ncurses
, mpd_clientlib, gettext, boost
, pcreSupport ? false
, pcre ? null
}:

with lib;

assert pcreSupport -> pcre != null;

stdenv.mkDerivation rec {
  pname = "ncmpc";
  version = "0.43";

  src = fetchFromGitHub {
    owner  = "MusicPlayerDaemon";
    repo   = "ncmpc";
    rev    = "v${version}";
    sha256 = "sha256-/bynLU4/QtUawBjhcaajjuUDUwaSt6zk4/4TZqfQX3c=";
  };

  buildInputs = [ glib ncurses mpd_clientlib boost ]
    ++ optional pcreSupport pcre;
  nativeBuildInputs = [ meson ninja pkg-config gettext ];

  mesonFlags = [
    "-Dlirc=disabled"
    "-Ddocumentation=disabled"
  ] ++ optional (!pcreSupport) "-Dregex=disabled";

  meta = with lib; {
    description = "Curses-based interface for MPD (music player daemon)";
    homepage    = "https://www.musicpd.org/clients/ncmpc/";
    license     = licenses.gpl2Plus;
    platforms   = platforms.all;
    maintainers = with maintainers; [ fpletz ];
  };
}
