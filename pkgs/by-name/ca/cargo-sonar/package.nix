{
  lib,
  rustPlatform,
  fetchFromGitLab,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-sonar";
  version = "1.6.0";

  src = fetchFromGitLab {
    owner = "woshilapin";
    repo = "cargo-sonar";
    tag = finalAttrs.version;
    hash = "sha256-c0P6lU26ofiAd/ALjbJbLai1gynGHIk9qmyzlanGwFw=";
  };

  cargoHash = "sha256-roLHT+YPDB+HfF0MScloTSq2G69dADSXSuzUphLivWk=";

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
