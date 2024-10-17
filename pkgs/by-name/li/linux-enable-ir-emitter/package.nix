{
  stdenv,
  lib,
  makeWrapper,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  argparse,
  gtk3,
  opencv,
  spdlog,
  usbutils,
  yaml-cpp,
}:
stdenv.mkDerivation rec {
  pname = "linux-enable-ir-emitter";
  version = "6.0.5";

  src = fetchFromGitHub {
    owner = "EmixamPP";
    repo = "linux-enable-ir-emitter";
    rev = version;
    hash = "sha256-djzsYE9PtRn7memfANA7xfotKPJGPw+8E1LgjPRA6l0=";
  };

  patches = [
    # prevent meson from creating subdir in /var
    ./install.patch
  ];

  nativeBuildInputs = [
    makeWrapper
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    argparse
    gtk3
    spdlog
    usbutils
    yaml-cpp
    (opencv.override { enableGtk3 = true; })
  ];

  meta = {
    description = "Provides support for infrared cameras that are not directly enabled out-of-the box";
    homepage = "https://github.com/EmixamPP/linux-enable-ir-emitter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fufexan ];
    mainProgram = "linux-enable-ir-emitter";
    platforms = lib.platforms.linux;
  };
}
