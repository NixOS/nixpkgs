{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "protox";
  version = "0.10.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-BQogOPwxCJUBnOGODPmP6fDyRSt5mKAxibsVeXMg7qU=";
  };

  cargoHash = "sha256-g+1k9ShdYGPoTmnR0JQoMBvL7eFW15R/BlMOFmftkWg=";

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
