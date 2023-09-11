{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "iroh";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "n0-computer";
    repo = pname;
    rev = "${pname}-v${version}";
    hash = "sha256-p1OvXso5szo8ZCnCTKgDzCEMJgiePXQMhVYOkWVZrbE=";
  };

  cargoHash = "sha256-QqMBEYaIQ6PqO7w7Yd1jVr0zHARsVaJtZzWytmDksZQ=";

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
  };
}
