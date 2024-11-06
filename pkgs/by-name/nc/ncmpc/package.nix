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
, fmt
, pcreSupport ? false, pcre ? null
}:

assert pcreSupport -> pcre != null;

stdenv.mkDerivation rec {
  pname = "ncmpc";
  version = "0.51";

  src = fetchFromGitHub {
    owner  = "MusicPlayerDaemon";
    repo   = "ncmpc";
    rev    = "v${version}";
    sha256 = "sha256-mFZ8szJT7eTPHQHxjpP5pThCcY0YERGkGR8528Xu9MA=";
  };

  buildInputs = [ glib ncurses libmpdclient boost fmt ]
    ++ lib.optional pcreSupport pcre;
  nativeBuildInputs = [ meson ninja pkg-config gettext ];

  mesonFlags = [
    "-Dlirc=disabled"
    "-Ddocumentation=disabled"
  ] ++ lib.optional (!pcreSupport) "-Dregex=disabled";

  meta = with lib; {
    description = "Curses-based interface for MPD (music player daemon)";
    homepage    = "https://www.musicpd.org/clients/ncmpc/";
    license     = licenses.gpl2Plus;
    platforms   = platforms.all;
    maintainers = with maintainers; [ fpletz ];
    mainProgram = "ncmpc";
  };
}
