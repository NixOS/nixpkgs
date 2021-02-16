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
  version = "0.44";

  src = fetchFromGitHub {
    owner  = "MusicPlayerDaemon";
    repo   = "ncmpc";
    rev    = "v${version}";
    sha256 = "sha256-Qu41TL8KSKC9L25D6Z8bEbJUJQ9QI08grTGZ+0qGdUQ=";
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
