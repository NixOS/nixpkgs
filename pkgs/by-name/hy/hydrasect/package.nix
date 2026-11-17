{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage {
  pname = "hydrasect";
  version = "0.1.0-unstable-2025-08-27";

  src = fetchFromGitHub {
    owner = "blitz";
    repo = "hydrasect";
    rev = "88161c6d8dce16bf832599cf8ab544bbe5857c00";
    hash = "sha256-Na7MlT+OXHZBtCKqJ0IzK4k3XfvQhsY+lnUJFG66YDU=";
  };

  cargoHash = "sha256-muqG74Ze6aUURPutuKlXvq5ayglJ7TGAzeji89lsoLk=";

  meta = {
    description = "Tool that makes bisecting nixpkgs pleasant";
    homepage = "https://github.com/blitz/hydrasect";
    license = lib.licenses.eupl12;
    maintainers = with lib.maintainers; [ kiara ];
    mainProgram = "hydrasect";
  };
}
