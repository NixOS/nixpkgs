{
  lib,
  rustPlatform,
  fetchFromGitHub,
  lm_sensors,
  usbutils,
  udevCheckHook,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "antec-flux-pro";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "Reikooters";
    repo = "antec-flux-pro-display";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1omQVWSIrwQIsB+pfhDz0N8A3T/qMRBlLseBxANMS9c=";
  };
  cargoHash = "sha256-GR/ZcT1v1Tv4KAfD+IldhkYwz0kaT/lhN6wXtMbmO9o=";

  buildInputs = [
    lm_sensors
    usbutils
  ];

  nativeBuildInputs = [
    udevCheckHook
  ];

  outputs = [
    "out"
    "udev"
  ];

  udevRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="2022", ATTR{idProduct}=="0522", GROUP="plugdev", TAG+="uaccess"
  '';

  passAsFile = [ "udevRules" ];

  postInstall = ''
    install -Dm644 "$udevRulesPath" $udev/lib/udev/rules.d/70-antec-flux-pro.rules
  '';

  meta = {
    homepage = "https://github.com/Reikooters/antec-flux-pro-display";
    description = "Antec Flux Pro Hardware Display Service";
    mainProgram = "antec-flux-pro-display";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.kruziikrel13 ];
  };
})
