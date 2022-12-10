{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, glib
, ncurses
, libmpdclient
, gettext
, boost
, pcreSupport ? false, pcre ? null
}:

with lib;

assert pcreSupport -> pcre != null;

stdenv.mkDerivation rec {
  pname = "ncmpc";
  version = "0.47";

  src = fetchFromGitHub {
    owner  = "MusicPlayerDaemon";
    repo   = "ncmpc";
    rev    = "v${version}";
    sha256 = "sha256-7vywLMiIUfRx9/fCmUH1AGUB63bT8z7wabgm3CuLLUs=";
  };

  buildInputs = [ glib ncurses libmpdclient boost ]
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
