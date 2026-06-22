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

stdenv.mkDerivation (finalAttrs: {
  pname = "ncmpc";
  version = "0.52";

  src = fetchFromGitHub {
    owner = "MusicPlayerDaemon";
    repo = "ncmpc";
    tag = "v${finalAttrs.version}";
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

  meta = {
    description = "Curses-based interface for MPD (music player daemon)";
    homepage = "https://www.musicpd.org/clients/ncmpc/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    badPlatforms = lib.platforms.darwin;
    maintainers = with lib.maintainers; [ fpletz ];
    mainProgram = "ncmpc";
  };
})
