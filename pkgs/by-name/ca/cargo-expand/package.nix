{
  lib,
  rustPlatform,
  fetchFromGitHub,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-expand";
  version = "1.0.123";

  src = fetchFromGitHub {
    owner = "dtolnay";
    repo = "cargo-expand";
    tag = finalAttrs.version;
    hash = "sha256-vd63DpKLZpE+fIdfy4gp9PDSSLICPXZdrjk7hMB9L0A=";
  };

  cargoHash = "sha256-mLpihgQ5PNRE72xWRHgcA8KxujR7Pi4bGnwahOQJ4qo=";

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
