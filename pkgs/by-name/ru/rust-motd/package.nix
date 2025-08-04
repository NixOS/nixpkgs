{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "rust-motd";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "rust-motd";
    repo = "rust-motd";
    rev = "v${version}";
    hash = "sha256-06iWk0VobdHP94eNaEyQnIBx5YkoW0/IQQtUFWTkEe0=";
  };

  cargoHash = "sha256-f+441tEy1+AWXsz2Byrg0+Tz8jHcC1SD9WNZlkgWGZ4=";

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
