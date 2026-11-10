{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  eslint_d,
  testers,
}:

buildNpmPackage rec {
  pname = "eslint_d";
  version = "15.1.0";

  src = fetchFromGitHub {
    owner = "mantoni";
    repo = "eslint_d.js";
    rev = "v${version}";
    hash = "sha256-PHprTzShYWqMAW/oaqgX5T4eiA3/wh+aZ3YSQfCY2Cg=";
  };

  npmDepsHash = "sha256-XdNPxKw9d9udHRsELrrjaq0iUxWYnDh7XpWFa8O46yg=";

  dontNpmBuild = true;

  passthru.tests.version = testers.testVersion {
    package = eslint_d;
    version = src.rev;
  };

  meta = {
    description = "Makes eslint the fastest linter on the planet";
    homepage = "https://github.com/mantoni/eslint_d.js";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ehllie ];
    mainProgram = "eslint_d";
  };
}
