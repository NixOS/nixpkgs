{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-expand";
  version = "1.0.127";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = "cargo-expand";
    tag = finalAttrs.version;
    hash = "sha256-IRNIWIvNYVB93Q9yEg3QSBgI4o0pH6Lv3CWI70GjJJM=";
  };

  cargoHash = "sha256-jFgbAtbMmNnyYE1qiNzWL3DKqSTB5fmd5/n2NmchavM=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cargo subcommand to show result of macro expansion";
    homepage = "https://github.com/dtolnay/cargo-expand";
    changelog = "https://github.com/dtolnay/cargo-expand/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      xrelkd
      defelo
    ];
    mainProgram = "cargo-expand";
  };
})
