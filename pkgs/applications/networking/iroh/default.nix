{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "iroh";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-a5Yd//ihJe7Li5JySoOops4UbO+978BRnZk/nBy07Aw=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
  };

  buildInputs = lib.optionals stdenv.isDarwin (
    with darwin.apple_sdk.frameworks; [
      Security
      SystemConfiguration
    ]
  );

  # Some tests require network access which is not available in nix build sandbox.
  doCheck = false;

  meta = with lib; {
    description = "Efficient IPFS for the whole world right now";
    homepage = "https://iroh.computer";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ cameronfyfe ];
    mainProgram = "iroh";
  };
}
