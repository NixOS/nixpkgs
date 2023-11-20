{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2_1_5
, openssl
, zlib
, stdenv
, darwin
}:

let
  version = "5.12.175";
in
rustPlatform.buildRustPackage {
  pname = "git-mit";
  inherit version;

  src = fetchFromGitHub {
    owner = "PurpleBooth";
    repo = "git-mit";
    rev = "v${version}";
    hash = "sha256-c026r3F/oNk/DyEwHb/1kSL99bqmYp7mqOdsWbB7Njo=";
  };

  cargoHash = "sha256-QpmgGonDy3Pkx2i5X3ZxmBXqupOoESoFMIBorFeqam4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    libgit2_1_5
    openssl
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.AppKit
  ];

  meta = with lib; {
    description = "Minimalist set of hooks to aid pairing and link commits to issues";
    homepage = "https://github.com/PurpleBooth/git-mit";
    changelog = "https://github.com/PurpleBooth/git-mit/releases/tag/v${version}";
    license = licenses.cc0;
    maintainers = with maintainers; [ figsoda ];
  };
}
