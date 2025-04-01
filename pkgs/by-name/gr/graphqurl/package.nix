{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "graphqurl";
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "hasura";
    repo = "graphqurl";
    rev = "v${version}";
    hash = "sha256-w7t3p7TOBA0nxUlfRfQkiZ26SCDCwv03A1r+pTgUCqc=";
  };

  npmDepsHash = "sha256-17eRYr0vgnq7eFtlYY2CwvluwhbXWClL3onTNBkDF0c=";

  dontNpmBuild = true;

  meta = {
    description = "CLI and JS library for making GraphQL queries";
    homepage = "https://github.com/hasura/graphqurl";
    license = lib.licenses.asl20;
    mainProgram = "gq";
    maintainers = with lib.maintainers; [ bbigras ];
  };
}
