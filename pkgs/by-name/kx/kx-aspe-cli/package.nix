{
  lib,
  rustPlatform,
  fetchFromGitea,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "kx-aspe-cli";
  version = "0-unstable-2024-04-06";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "keyoxide";
    repo = "kx-aspe-cli";
    rev = "492df7edae95a8636bb59c4e5c1607053dab2c78";
    hash = "sha256-xSJTwyHNqDHyH6dgwlWnvqNCzTvmFntk+XgAaxODWAY=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  cargoHash = "sha256-wOg81NvChOLPiCyhJ5dGn5sRskevpf0QdKwmgZa2/1s=";

  meta = {
    homepage = "https://codeberg.org/keyoxide/kx-aspe-cli";
    changelog = "https://codeberg.org/keyoxide/kx-aspe-cli/src/commit/${src.rev}/CHANGELOG.md";
    description = "Keyoxide profile generator CLI using ASPE";
    mainProgram = "kx-aspe";
    platforms = lib.platforms.linux;
    license = [ lib.licenses.asl20 ];
    maintainers = [ lib.maintainers.nobbz ];
  };
}
