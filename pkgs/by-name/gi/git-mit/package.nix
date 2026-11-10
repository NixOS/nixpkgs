{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  openssl,
  zlib,
}:

let
  version = "6.6.1";
in
rustPlatform.buildRustPackage {
  pname = "git-mit";
  inherit version;

  src = fetchFromGitHub {
    owner = "PurpleBooth";
    repo = "git-mit";
    tag = "v${version}";
    hash = "sha256-Lb4exaY036T7w6o8PIt/u+MEvqbSkWa17IY/4hhfv+E=";
  };

  cargoHash = "sha256-72moNRf55TNAwOeXJGwxbv7HTtE4viyEP0V4uCf10SA=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ];

  env = {
    LIBGIT2_NO_VENDOR = 1;
  };

  meta = {
    description = "Minimalist set of hooks to aid pairing and link commits to issues";
    homepage = "https://github.com/PurpleBooth/git-mit";
    changelog = "https://github.com/PurpleBooth/git-mit/releases/tag/v${version}";
    license = lib.licenses.cc0;
    maintainers = [ lib.maintainers.matthiasbeyer ];
  };
}
