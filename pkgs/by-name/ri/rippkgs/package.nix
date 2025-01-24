{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  sqlite,
}:

rustPlatform.buildRustPackage rec {
  pname = "rippkgs";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "replit";
    repo = "rippkgs";
    rev = "refs/tags/v${version}";
    hash = "sha256-k50q78ycjrFVFTDstTdOLF8aJjsUpQ3lFRbFD1nL8xM=";
  };

  cargoHash = "sha256-EQvIJXIQ6UrevNkhqMZddUde+6iNBcBTOaanimZNkaA=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    sqlite
  ];

  meta = {
    description = "CLI for indexing and searching packages in Nix expressions";
    homepage = "https://github.com/replit/rippkgs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cdmistman ];
    mainProgram = "rippkgs";
  };
}
