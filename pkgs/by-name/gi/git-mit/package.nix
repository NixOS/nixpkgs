{ lib
, rustPlatform
, fetchFromGitHub
, fetchpatch
, pkg-config
, libgit2
, openssl
, zlib
, stdenv
, darwin
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
    (fetchpatch {
      name = "libgit2-update.patch";
      url = "https://github.com/PurpleBooth/git-mit/pull/1543/commits/3e82a4f5017972c7d28151a468bb71fe7d2279e0.patch";
      hash = "sha256-M9RpZHjOpZZqdHQe57LwMZ9zX6/4BNg3ymz8H3qupFk=";
    })
  ];

  cargoHash = "sha256-uoS6vmHmOVkHS81mrsbbXqP/dAC/FNHAlpTDHSa632k=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
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
