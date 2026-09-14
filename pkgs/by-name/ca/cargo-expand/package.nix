{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-expand";
  version = "1.0.126";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = "cargo-expand";
    tag = finalAttrs.version;
    hash = "sha256-YiJyh2bti5eA02MvJxBPUs+xmfGerVy8kUhMMB2jwbo=";
  };

  cargoHash = "sha256-TjZ8GY7WjkTs5Nvi7w26evcHzcwUz+VAjl9y85+Cj5M=";

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
