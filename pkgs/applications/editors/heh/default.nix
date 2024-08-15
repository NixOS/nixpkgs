{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "heh";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "ndd7xv";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-P3EZSe5Zv7pJ2QwKvtBh5kz93y6DBWkj6s8v3+8Xp9Q=";
  };

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    AppKit
  ]);

  cargoHash = "sha256-l3XR6srs6RmvcGjMFni6wYLLqXE8mMUq59WFLKGQl3U=";

  meta = with lib; {
    description = "Cross-platform terminal UI used for modifying file data in hex or ASCII";
    homepage = "https://github.com/ndd7xv/heh";
    changelog = "https://github.com/ndd7xv/heh/releases/tag/${src.rev}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ piturnah ];
    mainProgram = "heh";
  };
}
