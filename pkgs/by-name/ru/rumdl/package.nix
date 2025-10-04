{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rumdl";
  version = "0.0.146";

  src = fetchFromGitHub {
    owner = "rvben";
    repo = "rumdl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0aeBVapWJ+1Y/D7WA1oYACD8Mr0tSLiv+ojJhZ3i3pI=";
  };

  cargoHash = "sha256-yrDf0+QMBzHhGNBTZp9gQNqH3USagpJklRDrUvjHnbw=";

  cargoBuildFlags = [
    "--bin=rumdl"
  ];

  useNextest = true;

  cargoTestFlags = [
    "--profile ci"
  ];

  checkFlags = [
    # Skip Windows tests
    "--skip comprehensive_windows_tests"
    "--skip windows_vscode_tests"
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
    description = "Markdown Linter";
    homepage = "https://github.com/rvben/rumdl";
    changelog = "https://github.com/rvben/rumdl/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      kachick
    ];
    mainProgram = "rumdl";
    platforms = with lib.platforms; unix ++ windows;
    broken = stdenv.hostPlatform.isDarwin; # LSP tests fail in checkPhase
  };
})
