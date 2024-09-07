{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "heh";
  version = "0.6.1";

  src = fetchFromGitHub {
    owner = "ndd7xv";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-eqWBTylvXqGhWdSGHdTM1ZURSD5pkUBoBOvBJ5zmJ7w=";
  };

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    AppKit
  ]);

  cargoHash = "sha256-rLZgKLL28/ZrXzHVI6m4YeV2mk4E9W58HjTzRl2bMOw=";

  meta = with lib; {
    description = "Cross-platform terminal UI used for modifying file data in hex or ASCII";
    homepage = "https://github.com/ndd7xv/heh";
    changelog = "https://github.com/ndd7xv/heh/releases/tag/${src.rev}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ piturnah ];
    mainProgram = "heh";
  };
}
