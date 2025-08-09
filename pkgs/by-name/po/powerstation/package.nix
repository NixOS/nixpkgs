{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  udev,
  pciutils,
  cmake,
}:

rustPlatform.buildRustPackage rec {
  pname = "powerstation";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "ShadowBlip";
    repo = "PowerStation";
    tag = "v${version}";
    hash = "sha256-UB0NmP2UaQEYGrFR0f0nBLuGTjjTIhvz0bwx3eC2JE4=";
  };

  cargoHash = "sha256-32tz1cJ2G3GXB9j0lFyjsAOn/iQGxzrdfcqkA/Yh4UY=";

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
    changelog = "https://github.com/ShadowBlip/PowerStation/releases/tag/v${version}";
    maintainers = with lib.maintainers; [ shadowapex ];
    mainProgram = "powerstation";
  };
}
