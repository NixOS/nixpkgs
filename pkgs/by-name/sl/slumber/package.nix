{ lib, stdenv, fetchFromGitHub, rustPlatform }:
rustPlatform.buildRustPackage rec {
  pname = "slumber";
  version = "1.0.1";

  # This release tarball includes source code for the tree-sitter grammars,
  # which is not ordinarily part of the repository.
  src = fetchFromGitHub {
    owner = "LucasPickering";
    repo = "slumber";
    rev = "v${version}";
    hash = "sha256-FXw3hVVY/f49leo9t+z52+Ti9XGk6UJDtd0VpQDQb/o=";
  };

  cargoHash = "sha256-odLFfq3qjCQUNDauFtlOaKrsYVspAIxAc/pRSEZyIwo=";

  meta = with lib; {
    description = "Terminal-based HTTP/REST client";
    homepage = "https://slumber.lucaspickering.me";
    license = licenses.mit;
    mainProgram = "slumber";
    maintainers = with maintainers; [ javaes ];
    broken = stdenv.isDarwin || stdenv.isAarch64;
  };
}
