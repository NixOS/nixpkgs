{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "gimoji";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "zeenix";
    repo = "gimoji";
    rev = version;
    hash = "sha256-fRAi+ac/NzG6FQZq6ohpan5ZNtiwJXLV6k1BsMwaJsg=";
  };

  cargoHash = "sha256-57A/D6XgedQEaTn+lx5Ce/O8wR2xO3ozemLQOOF8/84=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
  ];

  meta = with lib; {
    description = "Easily add emojis to your git commit messages";
    homepage = "https://github.com/zeenix/gimoji";
    license = licenses.mit;
    maintainers = with maintainers; [ a-kenji ];
  };
}
