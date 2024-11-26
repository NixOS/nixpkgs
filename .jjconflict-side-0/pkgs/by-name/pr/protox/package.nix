{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "protox";
  version = "0.5.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-U9+7k7dQ6YFfsKMfFMg34g42qLvn+mcSRlAAys3eXNo=";
  };

  cargoHash = "sha256-sNOw19gxj+cEctxhXNWI8u15VJYlN8nSNl6Ha9sB/eE=";

  buildFeatures = [ "bin" ];

  # tests are not included in the crate source
  doCheck = false;

  meta = with lib; {
    description = "Rust implementation of the protobuf compiler";
    mainProgram = "protox";
    homepage = "https://github.com/andrewhickman/protox";
    changelog = "https://github.com/andrewhickman/protox/blob/${version}/CHANGELOG.md";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ figsoda ];
  };
}
