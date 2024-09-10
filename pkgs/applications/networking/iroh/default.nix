{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "iroh";
  version = "0.24.0";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ZHBgsR17U0hWnRZ79S1/TXoOATofvlf3UloHQh1p8Oo=";
  };

  cargoHash = "sha256-j/Trm6Y64cOxBdHfP172E+YiORZ8B9ukJOpzrLTGI7k=";

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
