{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-swift";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "antoniusnaumann";
    repo = "cargo-swift";
    rev = "v${version}";
    hash = "sha256-ATpEo7s/qatK7hsbNo9tE97yMpymA1xmf879WrgUluM=";
  };

  cargoHash = "sha256-hKTvtPulltsxi0PX8Xmo9MYcQYuTdOOspfgLCaEKQL4=";

  meta = with lib; {
    description = "A cargo plugin to easily build Swift packages from Rust code";
    homepage = "https://github.com/antoniusnaumann/cargo-swift";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ elliot ];
  };
}
