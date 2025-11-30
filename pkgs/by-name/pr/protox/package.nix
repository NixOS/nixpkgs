{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "protox";
  version = "0.9.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-7vXh4wedBskF9qtAVZn0mevzUoy7rlBCnxqzKU6NXwQ=";
  };

  cargoHash = "sha256-+F4R99YsWUjJukEtAEeH/N/J3YqnhJ/YcATfbPOFjuo=";

  buildFeatures = [ "bin" ];

  # tests are not included in the crate source
  doCheck = false;

  meta = {
    description = "Rust implementation of the protobuf compiler";
    mainProgram = "protox";
    homepage = "https://github.com/andrewhickman/protox";
    changelog = "https://github.com/andrewhickman/protox/blob/${version}/CHANGELOG.md";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = [ ];
  };
}
