{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-swift";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "antoniusnaumann";
    repo = "cargo-swift";
    rev = "v${version}";
    hash = "sha256-v7ZZ3tMM8KmRk6y3uSw8ZBEcByQ95XQv3XPTUtDGUQ0=";
  };

  cargoHash = "sha256-K3xZytJJ9/CaHWHL1fX0vKYpzH9yz3xOs2J5PoZWWv0=";

  meta = with lib; {
    description = "A cargo plugin to easily build Swift packages from Rust code";
    homepage = "https://github.com/antoniusnaumann/cargo-swift";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ elliot ];
  };
}
