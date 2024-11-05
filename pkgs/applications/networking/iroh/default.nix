{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "iroh";
  version = "0.28.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Dy5p6KfrdSjQDL+osKTdScYP2L+ameFxDVXh10AZ1dM=";
  };

  cargoLock.lockFile = ./Cargo.lock;

  cargoLock.outputHashes = {
    "iroh-blobs-0.28.0" = "sha256-7I9Ijgxfg5PAiSpBbM//8ftDGPwDfDmM8B7ZGTih+hI=";
    "iroh-docs-0.28.0" = "sha256-BfP+erijTpcjbtQ1UpvwmlDm0lg/nvijYlpHaXuYRyw=";
    "iroh-gossip-0.28.0" = "sha256-I6Fyx0bq06BbbPGIWNze9Bt4eZrJt6GI9Zf5SuMIZWA=";
  };

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
