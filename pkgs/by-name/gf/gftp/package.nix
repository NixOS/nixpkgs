{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  gettext,
  gtk3,
  ncurses,
  openssl,
  pkg-config,
  readline,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gftp";
  version = "2.9.1b-unstable-2026-03-30";

  src = fetchFromGitHub {
    owner = "masneyb";
    repo = "gftp";
    rev = "f64d27b116be1fc444e0f50ec375847b72df65f7";
    hash = "sha256-2CVRIrSOBi1AUoEKiyYhMmGcIIBnwMQ3EQsgBIvlXEs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    gettext
    pkg-config
  ];

  buildInputs = [
    gtk3
    ncurses
    openssl
    readline
  ];

  hardeningDisable = [ "format" ];

  meta = {
    homepage = "https://github.com/masneyb/gftp";
    description = "GTK-based multithreaded FTP client for *nix-based machines";
    license = lib.licenses.gpl2Plus;
    maintainers = [ lib.maintainers.haylin ];
    platforms = lib.platforms.unix;
    mainProgram = "gftp";
  };
})
