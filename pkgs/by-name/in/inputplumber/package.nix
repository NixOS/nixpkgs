{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
  libiio,
  libevdev,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "inputplumber";
  version = "0.77.5";

  src = fetchFromGitHub {
    owner = "ShadowBlip";
    repo = "InputPlumber";
    tag = "v${finalAttrs.version}";
    hash = "sha256-L6Ebyh4K4l+7LlVlgDRym9o+XsQPExC7xH1EBPwyLB4=";
  };

  cargoHash = "sha256-avwKy2AvgzT2IfRw/aMwllaYa4RLx7DJPxrgjHwBY1I=";

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
    changelog = "https://github.com/ShadowBlip/InputPlumber/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ shadowapex ];
    mainProgram = "inputplumber";
  };
})
