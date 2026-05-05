{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  systemd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "qmk_hid";
  version = "0.1.13";

  src = fetchFromGitHub {
    owner = "FrameworkComputer";
    repo = "qmk_hid";
    rev = "v${finalAttrs.version}";
    hash = "sha256-GuI/hDqMEpJ5Flcs4hRXZr3pbVFreelJIlS/idViHmY=";
  };

  cargoHash = "sha256-s6SF6L+5YQ9/yNuyrPPM8xztvn6PUyaUD29M+C7kSnE=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    systemd
  ];

  checkFlags = [
    # test doesn't compile
    "--skip=src/lib.rs"
  ];

  meta = {
    description = "Commandline tool for interactng with QMK devices over HID";
    homepage = "https://github.com/FrameworkComputer/qmk_hid";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [
      telometto
    ];
    mainProgram = "qmk_hid";
  };
})
