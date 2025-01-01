{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "mdbook-emojicodes";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "blyxyas";
    repo = "mdbook-emojicodes";
    rev = "${version}";
    hash = "sha256-dlvfY2AMBvTl0j9YaT+u4CeWQGGihFD8AZaAK4/hUWU=";
  };

  cargoHash = "sha256-SkvAtV613+ARk79dB2zRKoLjPgdzoEKQa3JrRw9qBkA=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
  ];

  meta = with lib; {
    description = "MDBook preprocessor for converting emojicodes (e.g. `: cat :`) into emojis 🐱";
    mainProgram = "mdbook-emojicodes";
    homepage = "https://github.com/blyxyas/mdbook-emojicodes";
    changelog = "https://github.com/blyxyas/mdbook-emojicodes/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      blaggacao
      matthiasbeyer
    ];
  };
}
