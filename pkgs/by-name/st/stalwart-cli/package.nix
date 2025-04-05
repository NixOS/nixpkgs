{
  lib,
  rustPlatform,
  versionCheckHook,
  stalwart-mail,
}:

rustPlatform.buildRustPackage {
  inherit (stalwart-mail) src version cargoDeps;
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
  versionCheckProgramArg = "--version";

  # Prerelease reports incorrect version
  dontVersionCheck = true;

  meta = {
    inherit (stalwart-mail.meta) license homepage changelog;
    description = "Stalwart Mail Server CLI";
    mainProgram = "stalwart-cli";
    maintainers = with lib.maintainers; [
      giomf
    ];
  };
}
