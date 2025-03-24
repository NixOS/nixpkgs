{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "iroh";
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = "iroh";
    rev = "v${version}";
    hash = "sha256-GmgLPtg01sUrvno45IJEmhltuBWGXZnOI+Xeskz0BXg=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-xLNdZtzx6BZ0RJj3hfzo7ZZ0AeE1KAg51/FTJyLva6Y=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin (
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
