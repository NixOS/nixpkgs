{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "pfetch-rs";
  version = "2.11.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Gobidev";
    repo = "pfetch-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Kgoo8piv4pNqzw9zQSEj7POSK6l+0KMvaNbvMp+bpF8=";
  };

  cargoHash = "sha256-36MjBzSzEOVaSnd6dTqYnV+Pi+5EDoUskkYsvYMGrgg=";

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Rewrite of the pfetch system information tool in Rust";
    homepage = "https://github.com/Gobidev/pfetch-rs";
    changelog = "https://github.com/Gobidev/pfetch-rs/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gobidev ];
    mainProgram = "pfetch";
  };
})
