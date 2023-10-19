{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "gimoji";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "zeenix";
    repo = "gimoji";
    rev = version;
    hash = "sha256-7UzdZsidLHLZBj7mpRJQhvr3VP7HtkKPfAc7dnxS7kE=";
  };

  cargoHash = "sha256-oWImiIUFgy/pKHlZPPd1IWDG5l5LYCWTYJjgEqiXzLA=";

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
