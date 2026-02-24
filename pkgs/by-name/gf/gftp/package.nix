{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  gettext,
  gtk2,
  ncurses,
  openssl,
  pkg-config,
  readline,
  nix-update-script,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gftp";
  version = "2.9.1b-unstable-2025-05-12";

  src = fetchFromGitHub {
    owner = "masneyb";
    repo = "gftp";
    rev = "48114635f7b7b1f9a5eda985021ea53b10a7a030";
    hash = "sha256-unTsd2xX8Y71ItE3gYHoxUPgViK/xhZdx0IQYvDPaEc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    gettext
    pkg-config
  ];

  buildInputs = [
    gtk2
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
