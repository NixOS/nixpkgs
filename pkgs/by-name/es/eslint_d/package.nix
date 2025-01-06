{ lib, buildNpmPackage, fetchFromGitHub, eslint_d, testers }:

buildNpmPackage rec {
  pname = "eslint_d";
  version = "14.1.1";

  src = fetchFromGitHub {
    owner = "mantoni";
    repo = "eslint_d.js";
    rev = "v${version}";
    hash = "sha256-r+AQFFzB3PhvER6oVHpqQiFuaHuT+2O8gL2zu8aCTbs=";
  };

  npmDepsHash = "sha256-XOFRzGPrisXE8GyqVO5xms+o9OwA9w0y+uJkcdyX+z0=";

  dontNpmBuild = true;

  passthru.tests.version = testers.testVersion { package = eslint_d; version = src.rev; };

  meta = with lib; {
    description = "Makes eslint the fastest linter on the planet";
    homepage = "https://github.com/mantoni/eslint_d.js";
    license = licenses.mit;
    maintainers = [ maintainers.ehllie ];
    mainProgram = "eslint_d";
  };
}
