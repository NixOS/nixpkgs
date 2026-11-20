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
  version = "6.6.0";
in
rustPlatform.buildRustPackage {
  pname = "git-mit";
  inherit version;

  src = fetchFromGitHub {
    owner = "PurpleBooth";
    repo = "git-mit";
    tag = "v${version}";
    hash = "sha256-F9lU75X3Ysb1Lgjc0UVoyhBY1jrrgt5wEc4zjn18HjI=";
  };

  cargoHash = "sha256-hq05UxZ0wzfz1NVvxOUjpsZ3U7h3w/l4d6mdaoFmO8I=";

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
