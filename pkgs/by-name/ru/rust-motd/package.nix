{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "rust-motd";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "rust-motd";
    repo = "rust-motd";
    rev = "v${version}";
    hash = "sha256-NgNMTsm9C+0Lt6r1zYA486oSQpGIMxLsPozdDw7lILs=";
  };

  cargoHash = "sha256-pm/N00H840WzuP/BcvyqgZ/9zbNsHKm/UZ0O88giasY=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  OPENSSL_NO_VENDOR = 1;

  meta = {
    description = "Beautiful, useful MOTD generation with zero runtime dependencies";
    homepage = "https://github.com/rust-motd/rust-motd";
    changelog = "https://github.com/rust-motd/rust-motd/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ figsoda ];
    mainProgram = "rust-motd";
  };
}
