{ lib, stdenv, rustPlatform, fetchCrate, darwin }:

rustPlatform.buildRustPackage rec {
  pname = "nix-btm";
  version = "0.2.0";

  src = fetchCrate {
    inherit version;
    pname = "nix-btm";
    hash = "sha256-f8XFWlx+gwhF/OD8+tPcLGV/v0QnsDWOcqpY3Js+FAo=";
  };

  cargoHash = "sha256-qUZ3zJjQrteFQerBKFH/+Ys0uOzvI7DH9rCaVtseJMM=";

  buildInputs = lib.optionals stdenv.isDarwin
    (with darwin.apple_sdk.frameworks; [ CoreServices SystemConfiguration ]);

  meta = with lib; {
    description = "Rust tool to monitor Nix processes";
    homepage = "https://github.com/DieracDelta/nix-btm";
    license = licenses.mit;
    maintainers = with maintainers; [ DieracDelta ];
  };
}
