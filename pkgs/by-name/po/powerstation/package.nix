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
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "ShadowBlip";
    repo = "PowerStation";
    tag = "v${version}";
    hash = "sha256-SrVtVeG3rcQ0Og3Vm0S1bB8zETpj1oK11KJ288I3J9M=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-GTsYmSrr98ni8DrJ4klGb/Cph8ECc6pmJGv4WPv1Ap8=";

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
