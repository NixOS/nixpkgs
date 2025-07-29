{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "rust-motd";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "rust-motd";
    repo = "rust-motd";
    rev = "v${version}";
    hash = "sha256-pgmAf9izrIun6+EayxSNy9glTUFd0x/uy5r/aijVi4U=";
  };

  cargoHash = "sha256-TO2YCUmD+K4X7ArAPGCDhTH2W2UG8Ezr+yZjaQJTL0A=";

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
