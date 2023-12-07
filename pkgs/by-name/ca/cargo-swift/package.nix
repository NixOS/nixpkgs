{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-swift";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "antoniusnaumann";
    repo = "cargo-swift";
    rev = "v${version}";
    hash = "sha256-dW0/h7uS0BEstiochACIySSKXsz+E6Tj5MaLtdin7gw=";
  };

  cargoHash = "sha256-LsjDeKfAvgVYM4qYyWq9MoXB4jIh870urrFHpiGCGPc=";

  meta = with lib; {
    description = "A cargo plugin to easily build Swift packages from Rust code";
    homepage = "https://github.com/antoniusnaumann/cargo-swift";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ elliot ];
  };
}
