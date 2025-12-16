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
  version = "6.0.11";
in
rustPlatform.buildRustPackage {
  pname = "git-mit";
  inherit version;

  src = fetchFromGitHub {
    owner = "PurpleBooth";
    repo = "git-mit";
    tag = "v${version}";
    hash = "sha256-Hnmhvql7oTbNQnBvWlV60bxddH7H7intEsjfXhV4Z2Y=";
  };

  cargoHash = "sha256-4HNr/m+n+M1BaL67Fo/S4A9EXBYOIp7il0sAtm4rSQc=";

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
    maintainers = [ ];
  };
}
