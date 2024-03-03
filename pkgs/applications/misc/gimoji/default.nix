{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "gimoji";
  version = "0.7.6";

  src = fetchFromGitHub {
    owner = "zeenix";
    repo = "gimoji";
    rev = version;
    hash = "sha256-ipsEFZGC3JYOeNVI4AUb2c/9tt+TTIbeXuJ15ShEH6U=";
  };

  cargoHash = "sha256-786OPEaIHQtgUHlkjLprKfJ7VoeSW+IzHto3XXZ6Fu8=";

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
