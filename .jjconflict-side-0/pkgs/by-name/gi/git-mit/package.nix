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
  version = "5.14.3";
in
rustPlatform.buildRustPackage {
  pname = "git-mit";
  inherit version;

  src = fetchFromGitHub {
    owner = "PurpleBooth";
    repo = "git-mit";
    rev = "v${version}";
    hash = "sha256-+7rl4wxVQq4bLBsnLSeJD+1kkRuf7FCi81pXGrNNOPI=";
  };

  useFetchCargoVendor = true;

  cargoPatches = [
    # https://github.com/PurpleBooth/git-mit/pull/1543
    ./libgit2-update.patch
  ];

  cargoHash = "sha256-uoS6vmHmOVkHS81mrsbbXqP/dAC/FNHAlpTDHSa632k=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ];

  env = {
    LIBGIT2_NO_VENDOR = 1;
  };

  meta = with lib; {
    description = "Minimalist set of hooks to aid pairing and link commits to issues";
    homepage = "https://github.com/PurpleBooth/git-mit";
    changelog = "https://github.com/PurpleBooth/git-mit/releases/tag/v${version}";
    license = licenses.cc0;
    maintainers = with maintainers; [ figsoda ];
  };
}
