{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-expand";
  version = "1.0.120";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = "cargo-expand";
    tag = finalAttrs.version;
    hash = "sha256-KXnAKv8202Trkkr9D9HRmxTOZ67M2Jt4dhZ9o7D86uI=";
  };

  cargoHash = "sha256-eCDjGKLPy98SuknzzIE2GZEsxFjNZKuV30Y5nBQao3s=";

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
