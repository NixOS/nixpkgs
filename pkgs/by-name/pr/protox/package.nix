{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "protox";
  version = "0.9.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-3Bh+VDSsol2Pz3UVDSxx8KNJbzKParU/OoNcSNgVTJM=";
  };

  cargoHash = "sha256-Xcvl8c99M34sNd1R52M9eE2hh4lnbKL7vRHorlcJGss=";

  buildFeatures = [ "bin" ];

  # tests are not included in the crate source
  doCheck = false;

  meta = {
    description = "Rust implementation of the protobuf compiler";
    mainProgram = "protox";
    homepage = "https://github.com/andrewhickman/protox";
    changelog = "https://github.com/andrewhickman/protox/blob/${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = [ ];
  };
})
