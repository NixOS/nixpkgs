{
  lib,
  stdenv,
  fetchFromGitHub,
  glib,
  libgcrypt,
  libintl,
  libotr,
  meson,
  ncurses,
  ninja,
  openssl,
  perl,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "irssi";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "irssi";
    repo = "irssi";
    rev = finalAttrs.version;
    hash = "sha256-D+KMjkweStMqVhoQoiJPFt/G0vdf7x2FjYCvqGS8UqY=";
  };

  nativeBuildInputs = [
    meson
    ninja
    perl
    pkg-config
  ];

  buildInputs = [
    glib
    libgcrypt
    libintl
    libotr
    ncurses
    openssl
  ];

  configureFlags = [
    "-Dwith-proxy=yes"
    "-Dwith-bot=yes"
    "-Dwith-perl=yes"
  ];

  meta = {
    description = "Terminal based IRC client";
    mainProgram = "irssi";
    homepage = "https://irssi.org";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      fab
      lovek323
    ];
    platforms = lib.platforms.unix;
  };
})
