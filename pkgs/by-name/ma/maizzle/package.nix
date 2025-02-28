{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "maizzle";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "maizzle";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-Nzl4Pp1jY+LaQgLDJHjEdDA8b6MOfMXZNpvazPdmrTA=";
  };

  npmDepsHash = "sha256-ZPZALeuerHXAJuoCcqIwxsChuhBJ/zABYjb7+pcs4pU=";

  dontNpmBuild = true;

  meta = {
    description = "CLI tool for the Maizzle Email Framework";
    homepage = "https://github.com/maizzle/cli";
    license = lib.licenses.mit;
    mainProgram = "maizzle";
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
