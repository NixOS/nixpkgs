{
  lib,
  stdenv,
  fetchFromGitLab,
  pkg-config,
  libusb1,
}:

stdenv.mkDerivation rec {
  pname = "minipro";
  version = "0.7.2";

  src = fetchFromGitLab {
    owner = "DavidGriffith";
    repo = "minipro";
    rev = version;
    hash = "sha256-NIaBN+T/EzYBhBtBEIvIAmqmksYDDiMJsWm9zCzZOxE=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libusb1 ];
  makeFlags = [
    "VERSION=${version}"
    "PREFIX=$(out)"
    "UDEV_DIR=$(out)/lib/udev"
    "COMPLETIONS_DIR=$(out)/share/bash-completion/completions"
    "PKG_CONFIG=${pkg-config}/bin/${pkg-config.targetPrefix}pkg-config"
    "CC=${stdenv.cc.targetPrefix}cc"
    "CFLAGS=-O2"
  ];

  doInstallCheck = true;

  meta = with lib; {
    homepage = "https://gitlab.com/DavidGriffith/minipro";
    description = "Open source program for controlling the MiniPRO TL866xx series of chip programmers";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.bmwalters ];
    mainProgram = "minipro";
    platforms = platforms.unix;
  };
}
