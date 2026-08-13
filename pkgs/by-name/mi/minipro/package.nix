{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  libusb1,
  util-linux,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "minipro";
  version = "0.7.4";

  src = fetchFromGitLab {
    owner = "DavidGriffith";
    repo = "minipro";
    rev = finalAttrs.version;
    hash = "sha256-2Vi4NAKh+6N/at09egjS04ankEXnSHzsAIFSIau7jNc=";
  };

  nativeBuildInputs = [
    pkg-config
    util-linux
  ];
  buildInputs = [
    libusb1
    zlib
  ];
  makeFlags = [
    "VERSION=${finalAttrs.version}"
    "PREFIX=$(out)"
    "UDEV_DIR=$(out)/lib/udev"
    "COMPLETIONS_DIR=$(out)/share/bash-completion/completions"
    "PKG_CONFIG=${pkg-config}/bin/${pkg-config.targetPrefix}pkg-config"
    "CC=${stdenv.cc.targetPrefix}cc"
    "CFLAGS=-O2"
  ];

  doInstallCheck = true;

  meta = {
    homepage = "https://gitlab.com/DavidGriffith/minipro";
    description = "Open source program for controlling the MiniPRO TL866xx series of chip programmers";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.bmwalters ];
    mainProgram = "minipro";
    platforms = lib.platforms.unix;
  };
})
