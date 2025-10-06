{
  lib,
  rustPlatform,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  libgit2,
  openssl,
  zlib,
}:

let
  version = "5.14.4";
in
rustPlatform.buildRustPackage {
  pname = "git-mit";
  inherit version;

  src = fetchFromGitHub {
    owner = "PurpleBooth";
    repo = "git-mit";
    rev = "v${version}";
    hash = "sha256-8XWwzR9TiSCU6fKbrulKpCDFDEyzQpaT2nrahF8iac8=";
  };

  cargoPatches = [
    # https://github.com/PurpleBooth/git-mit/pull/1543
    ./libgit2-update.patch
  ];

  cargoHash = "sha256-B2XRdcwcFxMwnDl5ndIw72OEsn6D2Y8rIoeO4tclJkk=";

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
    maintainers = with lib.maintainers; [ figsoda ];
  };
}
