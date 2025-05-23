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
  version = "0.1.5-unstable-2023-02-20";

  src = fetchFromGitHub {
    owner = "oppiliappan";
    repo = "pista";
    rev = "378535f3e7e138110b6225616e0dc61066a5605a";
    hash = "sha256-FlWDKz5B/sC+VCtJNmtCJTkxzeOJOMT9gZlG6UVGzKU=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-Wforq2PHruQPFFLIiXzhulh+pZen6fFCfTktHJgt+Vw=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    zlib
  ];
  doCheck = false; # no tests
  meta = {
    description = "Simple {bash, zsh} prompt for programmers";
    homepage = "https://github.com/oppiliappan/pista";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ benjajaja ];
  };
}
