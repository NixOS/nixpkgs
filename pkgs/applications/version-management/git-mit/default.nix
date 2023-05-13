{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, openssl
, libgit2
, libssh2
, zlib
, pkg-config
}:

let
  version = "5.12.146";
in
rustPlatform.buildRustPackage {
  pname = "git-mit";
  inherit version;

  src = fetchFromGitHub {
    owner = "PurpleBooth";
    repo = "git-mit";
    rev = "v${version}";
    hash = "sha256-VN1TbK9wi5Nt2K3yKx2lYSP30zSpwNETQ4OyHj8zxBg=";
  };

  cargoHash = "sha256-YtUuRLjmehG+5kUiCo4LK0PkKAckr28UahlrAjm9MYw=";

  doCheck = true;

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl libgit2 libssh2 zlib ];

  meta = {
    description = "Minimalist set of hooks to aid pairing and link commits to issues";
    homepage = "https://github.com/PurpleBooth/git-mit";
    license = lib.licenses.cc0;
  };
}
