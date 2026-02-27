{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  dbus,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bluetui";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "pythops";
    repo = "bluetui";
    rev = "v${finalAttrs.version}";
    hash = "sha256-K+QAU9/XdGZonsKjBXbPbpJhWIHyaqxP6eb670n81LU=";
  };

  cargoHash = "sha256-i77j7hKtVxDDiHEBz5E7iwGXWYg0f/NfwFnN71QfgPU=";

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
