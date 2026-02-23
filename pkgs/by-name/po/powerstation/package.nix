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
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "ShadowBlip";
    repo = "PowerStation";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VmykW8Z6qJJNqSJR1diHN8/9R/Hkugqo1bmXOPURzMI=";
  };

  cargoHash = "sha256-gAYol2U/qxxoAKoAcQZ/P8FrcmWcQBoFvyAdixyYHYk=";

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
