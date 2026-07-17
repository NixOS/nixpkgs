{
  lib,
  fetchCrate,
  rustPlatform,
  nix-update-script,
  testers,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-shear";
  version = "1.13.2";

  src = fetchCrate {
    pname = "cargo-shear";
    version = finalAttrs.version;
    hash = "sha256-69OwhT4vc4xwvuVxZ0C7F/Us01TsuYJnnTKT6PHsOF8=";
  };

  cargoHash = "sha256-x0lZ8E/P9IaPSdzUo2O3t5qR2I3959So9uaAm4PBM4E=";

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
    description = "Detect and fix unused/misplaced dependencies from Cargo.toml";
    mainProgram = "cargo-shear";
    homepage = "https://github.com/Boshen/cargo-shear";
    changelog = "https://github.com/Boshen/cargo-shear/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.cathalmullan ];
  };
})
