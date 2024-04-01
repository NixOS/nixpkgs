{ lib
, buildNpmPackage
, fetchFromGitHub
}: buildNpmPackage rec {
  pname = "arrpc";
  version = "3.3.1";

  src = fetchFromGitHub {
    owner = "OpenAsar";
    repo = "arrpc";
    # Release commits are not tagged
    # release: 3.3.0
    rev = "b4796fffe3bf1b1361cc4781024349f7a4f9400e";
    hash = "sha256-iEfV85tRl2KyjodoaSxVHiqweBpLeiCAYWc8+afl/sA=";
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
