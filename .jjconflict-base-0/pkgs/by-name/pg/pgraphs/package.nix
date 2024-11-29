{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "pgraphs";
  version = "0.6.17";

  src = fetchFromGitHub {
    owner = "pg-format";
    repo = "pgraphs";
    rev = "refs/tags/v${version}";
    hash = "sha256-0Zo8Vg2KHhEGvO+vrbcP0ZTnfLtNTE2fqxq5LwPsJGs=";
  };

  npmDepsHash = "sha256-47zT3wlCnVIcv0Sst4lUWLUMiWftgvP60cOmHu65vB8=";
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
