{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
  pciutils,
  cmake,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "powerstation";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "ShadowBlip";
    repo = "PowerStation";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/8NpEPHGqqx8Xkibfx8aZUzPfCXBC2JgLWaHmGuG8FU=";
  };

  cargoHash = "sha256-qEOcXAHgYw/5HEPFHjILYcTuxVXjBMegiAajEGTUPSM=";

  nativeBuildInputs = [
    cmake
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    udev
    pciutils
  ];

  postInstall = ''
    cp -r rootfs/usr/* $out/
  '';

  meta = {
    description = "Open source TDP control and performance daemon with DBus interface";
    homepage = "https://github.com/ShadowBlip/PowerStation";
    license = lib.licenses.gpl3Plus;
    changelog = "https://github.com/ShadowBlip/PowerStation/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ shadowapex ];
    mainProgram = "powerstation";
  };
})
