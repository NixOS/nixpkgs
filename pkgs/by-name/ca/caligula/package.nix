{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "caligula";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "ifd3f";
    repo = "caligula";
    rev = "v${version}";
    hash = "sha256-9+aLpxmMP76CsLFFmr1mhKgbaT7Zz0lx4D2jQCUA9VY=";
  };

  cargoHash = "sha256-VwtmU5jTQPn3hpNuLckPQl6joEFPfuax1gRVG0/nceg=";

  buildInputs = lib.optionals stdenv.isDarwin (
    with darwin.apple_sdk.frameworks; [
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
    maintainers = with maintainers; [ sodiboo ];
    platforms = platforms.linux ++ platforms.darwin;
    # https://github.com/ifd3f/caligula/issues/105
    broken = stdenv.hostPlatform.isDarwin;
    mainProgram = "caligula";
  };
}
