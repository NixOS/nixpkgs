{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-expand";
  version = "1.0.119";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = "cargo-expand";
    tag = finalAttrs.version;
    hash = "sha256-N48BUPnVnMJSiM3EzpSiDNLGZNWFW05toHRhokNO5gI=";
  };

  cargoHash = "sha256-a8swmPQ+JuE/tqRYbV+kekZV8TloxszYq9k8VOGRBrM=";

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
