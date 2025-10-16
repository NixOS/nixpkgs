{
  lib,
  fetchFromGitHub,
  pkg-config,
  openssl,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "hashcards";
  version = "0-unstable-2025-10-11";

  src = fetchFromGitHub {
    owner = "eudoxia0";
    repo = "hashcards";
    rev = "ef6d4e70c7108a07edb88b34170d4ecb6d115dc7";
    hash = "sha256-h3MQxcHdvkL3FQArvoYj+YACnyBNzFF//lZZl6dokUU=";
  };

  cargoHash = "sha256-2Rzc30QVDTsSEk3DLxqvPFN/Bu++1WVXFDMmvFCUAdU=";

  nativeBuildInputs = [
    openssl
    pkg-config
  ];

  # For some reason, the pkg-config hook does not work for openssl
  PKG_CONFIG_PATH = "${openssl.dev}/lib/pkgconfig";

  meta = {
    description = "Text-based spaced repetition system";
    mainProgram = "hashcards";
    homepage = "https://github.com/eudoxia0/hashcards";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ rmgaray ];
  };
}
