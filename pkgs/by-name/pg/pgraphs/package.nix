{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "pgraphs";
  version = "0.6.12";

  src = fetchFromGitHub {
    owner = "pg-format";
    repo = "pgraphs";
    rev = "refs/tags/v${version}";
    hash = "sha256-rhNXASSHgdL9knq9uPFhAGlh0ZAKo5TNh/2a4u6Mh1U=";
  };

  npmDepsHash = "sha256-S1pCmRaRuprqIjaylIsuHyguhgQC5vvp7pDq2KJgrHQ=";
  dontNpmBuild = true;

  meta = {
    description = "Property Graph Exchange Format (PG) converter";
    changelog = "https://github.com/pg-format/pgraphs/blob/v${version}/CHANGELOG.md";
    homepage = "https://github.com/pg-format/pgraphs";
    license = lib.licenses.mit;
    mainProgram = "pgraphs";
    maintainers = with lib.maintainers; [ luftmensch-luftmensch ];
  };
}
