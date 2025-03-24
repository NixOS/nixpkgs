{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  sphinx,
  glib,
  ncurses,
  libmpdclient,
  gettext,
  boost,
  fmt,
  pcre2,
}:

stdenv.mkDerivation rec {
  pname = "ncmpc";
  version = "0.52";

  src = fetchFromGitHub {
    owner = "MusicPlayerDaemon";
    repo = "ncmpc";
    tag = "v${version}";
    sha256 = "sha256-j/hZdKl1LQ/yEGDUv9k5PQJ6pngAl52mVCpfacWrRw0=";
  };

  buildInputs = [
    glib
    ncurses
    libmpdclient
    boost
    fmt
    pcre2
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gettext
    sphinx
  ];

  mesonFlags = [
    (lib.mesonEnable "lirc" false)
  ];

  outputs = [
    "out"
    "doc"
  ];

  meta = with lib; {
    description = "Curses-based interface for MPD (music player daemon)";
    homepage = "https://www.musicpd.org/clients/ncmpc/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    badPlatforms = platforms.darwin;
    maintainers = with maintainers; [ fpletz ];
    mainProgram = "ncmpc";
  };
}
