{
  lib,
  rustPlatform,
  fetchFromGitLab,
  versionCheckHook,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-sonar";
  version = "1.3.0";

  src = fetchFromGitLab {
    owner = "woshilapin";
    repo = "cargo-sonar";
    tag = finalAttrs.version;
    hash = "sha256-f319hi6mrnlHTvsn7kN2wFHyamXtplLZ8A6TN0+H3jY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-KLw6kAR2pF5RFhRDfsL093K+jk3oiSHLZ2CQvrBuhWY=";

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
