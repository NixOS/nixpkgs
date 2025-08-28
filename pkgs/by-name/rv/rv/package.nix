{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rv";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "spinel-coop";
    repo = "rv";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DldUsSaVya5LD+0AHSlZXbJ05SNcew+7ryM3PlAMZEk=";
  };

  cargoHash = "sha256-yg9zW2keIQwdi0ky0JQ2MnKb+7GqYLUzbHM4ckAQVDQ=";

  cargoBuildFlags = [
    "--all-features"
  ];

  cargoTestFlags = [
    "--all-features"
  ];

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  # Skip integration tests requiring pre-built Ruby executables.
  checkFlags = [
    "--skip=ruby::find_test::"
    "--skip=ruby::list_test::"
    "--skip=shell::env_test::"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  versionCheckProgramArg = "--version";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Ruby version manager";
    homepage = "https://github.com/spinel-coop/rv";
    changelog = "https://github.com/spinel-coop/rv/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "rv";
  };
})
