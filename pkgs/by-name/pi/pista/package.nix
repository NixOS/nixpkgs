{
  stdenv,
  lib,
  fetchFromGitHub,
  rustPlatform,
  darwin,
  zlib,
}:

rustPlatform.buildRustPackage rec {
  pname = "pista";
  version = "unstable-2023-02-20";

  src = fetchFromGitHub {
    owner = "oppiliappan";
    repo = "pista";
    rev = "378535f3e7e138110b6225616e0dc61066a5605a";
    hash = "sha256-FlWDKz5B/sC+VCtJNmtCJTkxzeOJOMT9gZlG6UVGzKU=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-ADollmF60nJN8tnOZRCi755enFhf6A6M/1xqow9z110=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
    zlib
  ];

  meta = {
    description = "Simple {bash, zsh} prompt for programmers";
    homepage = "https://github.com/oppiliappan/pista";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ benjajaja ];
  };
}
