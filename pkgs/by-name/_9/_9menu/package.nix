{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  meson,
  ninja,
  libX11,
  libXext,
}:

stdenv.mkDerivation {
  pname = "9menu";
  version = "unstable-2021-02-24";

  src = fetchFromGitHub {
    owner = "arnoldrobbins";
    repo = "9menu";
    rev = "00cbf99c48dc580ca28f81ed66c89a98b7a182c8";
    sha256 = "arca8Gbr4ytiCk43cifmNj7SUrDgn1XB26zAhZrVDs0=";
  };

  nativeBuildInputs = [
    pkg-config
    meson
    ninja
  ];
  buildInputs = [
    libX11
    libXext
  ];

  meta = {
    homepage = "https://github.com/arnoldrobbins/9menu";
    description = "Simple X11 menu program for running commands";
    mainProgram = "9menu";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ];
    platforms = libX11.meta.platforms;
  };
}
