{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbus,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bluetui";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "pythops";
    repo = "bluetui";
    rev = "v${finalAttrs.version}";
    hash = "sha256-4qQx2njOqA2RABOoMCDTU+t0ZB4iscqJxjyTuKOJjdw=";
  };

  cargoHash = "sha256-CRpKBRvyZjo/zwoTigGRdztg86NhCijS7Da2w9CbyQM=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
  ];

  meta = {
    description = "TUI for managing bluetooth on Linux";
    homepage = "https://github.com/pythops/bluetui";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      donovanglover
      matthiasbeyer
    ];
    mainProgram = "bluetui";
    platforms = lib.platforms.linux;
  };
})
