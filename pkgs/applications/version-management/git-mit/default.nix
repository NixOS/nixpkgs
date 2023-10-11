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
  version = "5.12.157";
in
rustPlatform.buildRustPackage {
  pname = "git-mit";
  inherit version;

  src = fetchFromGitHub {
    owner = "PurpleBooth";
    repo = "git-mit";
    rev = "v${version}";
    hash = "sha256-Okb+HOCgtGLKSbhmhwA63BxS43ulZlSkHDOPsYzO2ZE=";
  };

  cargoHash = "sha256-I3sP6nhjMBXnANRrPT3+3HlY62TvfX6lFea7tHefOV8=";

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
