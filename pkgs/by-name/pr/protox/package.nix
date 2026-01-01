{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "protox";
<<<<<<< HEAD
  version = "0.9.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-3Bh+VDSsol2Pz3UVDSxx8KNJbzKParU/OoNcSNgVTJM=";
  };

  cargoHash = "sha256-Xcvl8c99M34sNd1R52M9eE2hh4lnbKL7vRHorlcJGss=";
=======
  version = "0.9.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-7vXh4wedBskF9qtAVZn0mevzUoy7rlBCnxqzKU6NXwQ=";
  };

  cargoHash = "sha256-+F4R99YsWUjJukEtAEeH/N/J3YqnhJ/YcATfbPOFjuo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
