{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "heh";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "ndd7xv";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-zkb+HogwioqxZ+BTl7bcDQx9i9uWhT2QdAIXpHqvDl0=";
  };

  buildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [
    AppKit
  ]);

  cargoHash = "sha256-YcTaLq04NhmnJ1pdbiKMRIBSFvHNWNgoAS8Uz8uGGAw=";

  meta = with lib; {
    description = "A cross-platform terminal UI used for modifying file data in hex or ASCII.";
    homepage = "https://github.com/ndd7xv/heh";
    changelog = "https://github.com/ndd7xv/heh/releases/tag/${src.rev}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ piturnah ];
    mainProgram = "heh";
  };
}
