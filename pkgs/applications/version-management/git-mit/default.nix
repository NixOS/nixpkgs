{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2
, openssl
, zlib
, stdenv
, darwin
}:

let
  version = "5.12.203";
in
rustPlatform.buildRustPackage {
  pname = "git-mit";
  inherit version;

  src = fetchFromGitHub {
    owner = "PurpleBooth";
    repo = "git-mit";
    rev = "v${version}";
    hash = "sha256-8sxC8peASy13Q582DbHHpQUj0AZN0soJrOocuPyJeHI=";
  };

  cargoHash = "sha256-zDUANe5zQNufPepbFoADkfjtEAE48GkMCpmG41OP2og=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
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
