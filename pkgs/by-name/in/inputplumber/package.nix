{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
  libiio,
  libevdev,
}:

rustPlatform.buildRustPackage rec {
  pname = "inputplumber";
  version = "0.62.2";

  src = fetchFromGitHub {
    owner = "ShadowBlip";
    repo = "InputPlumber";
    tag = "v${version}";
    hash = "sha256-dtRQeB2E/setGm0DEM/ikywU0LIRhOOjyRV0yuvuJQU=";
  };

  cargoHash = "sha256-EGIBBriAhqeAUQqlWPcAGdBAYWmYYnvc3ncYGc0ir3o=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    udev
    libevdev
    libiio
  ];

  postInstall = ''
    cp -r rootfs/usr/* $out/
  '';

  meta = {
    description = "Open source input router and remapper daemon for Linux";
    homepage = "https://github.com/ShadowBlip/InputPlumber";
    license = lib.licenses.gpl3Plus;
    changelog = "https://github.com/ShadowBlip/InputPlumber/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ shadowapex ];
    mainProgram = "inputplumber";
  };
}
