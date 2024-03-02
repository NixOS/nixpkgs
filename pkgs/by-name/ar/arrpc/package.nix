{ lib
, buildNpmPackage
, fetchFromGitHub
}: buildNpmPackage rec {
  pname = "arrpc";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "OpenAsar";
    repo = "arrpc";
    # Release commits are not tagged
    # release: 3.3.0
    rev = "c6e23e7eb733ad396d3eebc328404cc656fed581";
    hash = "sha256-OeEFNbmGp5SWVdJJwXZUkkNrei9jyuPc+4E960l8VRA=";
  };

  npmDepsHash = "sha256-YlSUGncpY0MyTiCfZcPsfcNx3fR+SCtkOFWbjOPLUzk=";

  dontNpmBuild = true;

  meta = {
    # ideally we would do blob/${version}/changelog.md here
    # upstream does not tag releases
    changelog = "https://github.com/OpenAsar/arrpc/blob/${src.rev}/changelog.md";
    description = "Open Discord RPC server for atypical setups";
    homepage = "https://arrpc.openasar.dev/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anomalocaris NotAShelf ];
    mainProgram = "arrpc";
  };
}
