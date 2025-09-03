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
  version = "0.60.8";

  src = fetchFromGitHub {
    owner = "ShadowBlip";
    repo = "InputPlumber";
    tag = "v${version}";
    hash = "sha256-k3SkjLjtCRionDwi2S/pZ40ShKgbsbQhBuLAs3Kd458=";
  };

  cargoHash = "sha256-i9mFQ12z3YE6Kb89Tt27reG1Y3rUmzTkAlT4Zd8rgXg=";

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
