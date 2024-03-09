{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "gimoji";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "zeenix";
    repo = "gimoji";
    rev = version;
    hash = "sha256-O4rIla/vpei+N2TXB2eIrFAkOyguE9gCQgVptl2mn0w=";
  };

  cargoHash = "sha256-ne7b95snaoji3mF3yN6ZvTSnQxJvLT7jOMbh5U10YgU=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
  ];

  meta = with lib; {
    description = "Easily add emojis to your git commit messages";
    homepage = "https://github.com/zeenix/gimoji";
    license = licenses.mit;
    mainProgram = "gimoji";
    maintainers = with maintainers; [ a-kenji ];
  };
}
