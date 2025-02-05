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
    tag = "v${version}";
    hash = "sha256-k50q78ycjrFVFTDstTdOLF8aJjsUpQ3lFRbFD1nL8xM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-RW7FBg5aLaNVFDEM4IvpS5gnb2luqWH2ya/7gKKOp4A=";

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
