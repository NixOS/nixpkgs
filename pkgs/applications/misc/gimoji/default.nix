{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "gimoji";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "zeenix";
    repo = "gimoji";
    rev = version;
    hash = "sha256-8aMm6OHDYBGvLYrQmQh33SI3jap6fS7lgOYDn9lWS18=";
  };

  cargoHash = "sha256-IENW19FlqWLk7K0+r9IUhXkS7C/wmik2bGDZdRk0jzA=";

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
