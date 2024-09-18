{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "iroh";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-hF1Nf4+uJXVPpkfsLFKjySMmCSmJdX2LeSHNb0vrBoA=";
  };

  cargoHash = "sha256-t1re2vpxGZkC45n0jUytqe2SPAC/+fh4Itq1h9znYnM=";

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
