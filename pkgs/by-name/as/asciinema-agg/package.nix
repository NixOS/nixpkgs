{ lib, rustPlatform, fetchFromGitHub, stdenv, darwin }:

let
  inherit (darwin.apple_sdk.frameworks) Security;
in
rustPlatform.buildRustPackage rec {
  pname = "agg";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "asciinema";
    repo = "agg";
    rev = "v${version}";
    hash = "sha256-WCUYnveTWWQOzhIViMkSnyQ6vgLs5HDLWa/xvfZMh3A=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "avt-0.8.0" = "sha256-5IN8P/2UWJ2EmkbbTSGWECTqiD8TeOd8LgwLZ+W2z90=";
    };
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    Security
  ];

  strictDeps = true;

  meta = {
    homepage = "https://github.com/asciinema/agg";
    description = "Command-line tool for generating animated GIF files from asciicast v2 files produced by asciinema terminal recorder";
    changelog = "https://github.com/asciinema/agg/releases/tag/${src.rev}";
    license = lib.licenses.asl20;
    mainProgram = "agg";
    maintainers = with lib.maintainers; [ figsoda ];
  };
}
