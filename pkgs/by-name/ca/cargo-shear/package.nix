{
  lib,
  fetchCrate,
  rustPlatform,
  nix-update-script,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-shear";
  version = "1.6.3";

  src = fetchCrate {
    pname = "cargo-shear";
    version = finalAttrs.version;
    hash = "sha256-8aRIDzMaVbu0oKU1Ufig3rBj/X8P/DPzUdrTfA77z0w=";
  };

  cargoHash = "sha256-A29u5ZI6zKUuBtpEEVkM4dVbTqETZlK8f33MG8V1SwE=";

  env = {
    # https://github.com/Boshen/cargo-shear/blob/v1.6.2/src/lib.rs#L51-L54
    SHEAR_VERSION = finalAttrs.version;
  };

  # Integration tests require network access
  cargoTestFlags = [
    "--lib"
  ];

  passthru = {
    updateScript = nix-update-script { };
    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
      };
    };
  };

  meta = {
    description = "Detect and remove unused dependencies from Cargo.toml";
    mainProgram = "cargo-shear";
    homepage = "https://github.com/Boshen/cargo-shear";
    changelog = "https://github.com/Boshen/cargo-shear/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.cathalmullan ];
  };
})
