{ lib, stdenv, fetchFromGitHub, rustPlatform }:
rustPlatform.buildRustPackage rec {
  pname = "slumber";
  version = "1.1.0";

  # This release tarball includes source code for the tree-sitter grammars,
  # which is not ordinarily part of the repository.
  src = fetchFromGitHub {
    owner = "LucasPickering";
    repo = "slumber";
    rev = "v${version}";
    hash = "sha256-398XqowI3zEgiU1XolLj3q1m4foC6aGGL+B3Q4plbTw=";
  };

  cargoHash = "sha256-AK/+1tCdvNucIbxwyqOt/TbOaJPVDOKFEx5NqW2Yd4U=";

  meta = with lib; {
    description = "Terminal-based HTTP/REST client";
    homepage = "https://slumber.lucaspickering.me";
    license = licenses.mit;
    mainProgram = "slumber";
    maintainers = with maintainers; [ javaes ];
    broken = stdenv.isDarwin || stdenv.isAarch64;
  };
}
