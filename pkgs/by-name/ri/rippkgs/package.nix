{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, sqlite
}:

rustPlatform.buildRustPackage rec {
  pname = "rippkgs";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "replit";
    repo = "rippkgs";
    rev = "refs/tags/v${version}";
    hash = "sha256-qQZnD9meczfsQv1R68IiUfPq730I2IyesurrOhtA3es=";
  };

  cargoHash = "sha256-hGSHgJ2HVCNqTBsTQIZlSE89FKqdMifuJyAGl3utF2I=";

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
    maintainers = with lib.maintainers; [ eclairevoyant cdmistman ];
    mainProgram = "rippkgs";
  };
}
