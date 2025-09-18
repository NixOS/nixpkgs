{
  lib,
  rustPlatform,
  fetchFromGitLab,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-sonar";
  version = "1.3.1";

  src = fetchFromGitLab {
    owner = "woshilapin";
    repo = "cargo-sonar";
    tag = finalAttrs.version;
    hash = "sha256-QK5hri+H1sphk+/0gU5iGrFo6POP/sobq0JL7Q+rJcc=";
  };

  cargoHash = "sha256-d6LXzWjt2Esbxje+gc8gRA72uxHE2kTUNKdhDlAP0K0=";

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
