{
  lib,
  rustPlatform,
  versionCheckHook,
  stalwart,
}:

rustPlatform.buildRustPackage {
  inherit (stalwart) src version cargoDeps;
  pname = "stalwart-cli";

  cargoBuildFlags = [
    "--package"
    "stalwart-cli"
  ];
  cargoTestFlags = [
    "--package"
    "stalwart-cli"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  # Prerelease reports incorrect version
  dontVersionCheck = true;

  meta = {
    inherit (stalwart.meta) license homepage changelog;
    description = "Stalwart Mail Server CLI";
    mainProgram = "stalwart-cli";
    maintainers = with lib.maintainers; [
      giomf
    ];
  };
}
