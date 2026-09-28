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
  version = "6.5.4";
in
rustPlatform.buildRustPackage {
  pname = "git-mit";
  inherit version;

  src = fetchFromGitHub {
    owner = "PurpleBooth";
    repo = "git-mit";
    tag = "v${version}";
    hash = "sha256-X8PNsYhhFgcBZQojOTBh0SN+trO6lstwWzLbo0a1Do4=";
  };

  cargoHash = "sha256-6lKCtNPEKanVxweY8WcyOXnyLOdDMfRPoN/b6bxmKdA=";

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
