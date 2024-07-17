{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "caligula";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "ifd3f";
    repo = "caligula";
    rev = "v${version}";
    hash = "sha256-nLt+PDPdW7oEMoWqW0iO4nXGlwk7UymWShn0azQt2ro=";
  };

  cargoHash = "sha256-8K3twPL7lNUmUUjD+nKATGgcjgoCuFO+bvlujVySXj0=";

  buildInputs = lib.optionals stdenv.isDarwin (
    with darwin.apple_sdk.frameworks;
    [
      Cocoa
      IOKit
      Foundation
      DiskArbitration
    ]
  );

  RUSTFLAGS = "--cfg tracing_unstable";

  meta = with lib; {
    description = "A user-friendly, lightweight TUI for disk imaging";
    homepage = "https://github.com/ifd3f/caligula/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
      ifd3f
      sodiboo
    ];
    platforms = platforms.linux ++ platforms.darwin;
    # https://github.com/ifd3f/caligula/issues/105
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "caligula";
  };
}
