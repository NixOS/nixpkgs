{
  lib,
  rustPlatform,
  fetchFromGitLab,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-sonar";
  version = "1.5.0";

  src = fetchFromGitLab {
    owner = "woshilapin";
    repo = "cargo-sonar";
    tag = finalAttrs.version;
    hash = "sha256-OcJG4UlxJvk888LKbXOFT/AaORzFrp/2dPR2ix3u2xY=";
  };

  cargoHash = "sha256-zjDJzHRIKa81sHDJMAXhOsW4IeFf2DBfyEAqQJQUjEk=";

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Utility to produce some Sonar-compatible format from different Rust tools like cargo-clippy cargo-audit or cargo-outdated";
    mainProgram = "cargo-sonar";
    homepage = "https://gitlab.com/woshilapin/cargo-sonar";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.jonboh ];
  };
})
