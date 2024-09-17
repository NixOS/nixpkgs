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
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "kixelated";
    repo = "moq-rs";
    rev = "moq-relay-v${version}";
    hash = "sha256-/2+2785FGXErG0uNVuReaf/GCFv2gypMOnrAXrA4qvs=";
  };

  cargoHash = "sha256-ih1UXbTHQA3wjkmajT1rHN1BUlOE/nkD+EUay1R3twE=";

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
