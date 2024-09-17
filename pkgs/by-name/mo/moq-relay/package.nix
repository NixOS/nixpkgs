{
  lib,
  stdenv,
  fetchFromGitHub,
  libressl,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "moq-relay";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "kixelated";
    repo = "moq-rs";
    rev = "moq-relay-v${version}";
    hash = "sha256-J9f+opePgvtsi7LfK7cH0kScB5xfZttY0Nrg89cypMs=";
  };

  cargoHash = "sha256-34bvlV7IJ0bn6Ghr6qH8Yh08xt2v17Mnj2Ej0h1pHM4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libressl ];

  meta = {
    description = "Media Over QUIC relay server";
    mainProgram = "moq-relay";
    homepage = "https://quic.video/";
    license = lib.licenses.asl20;
    changelog = "https://github.com/kixelated/moq-rs/releases/tag/moq-relay-v${version}";
    maintainers = [ lib.maintainers.therishidesai ];
  };
}
