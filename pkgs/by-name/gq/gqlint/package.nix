{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "gqlint";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "happylinks";
    repo = "gqlint";
    rev = "v${version}";
    hash = "sha256-m/Y7i3+93UdPnKQlZUHgtRbfSmJ1xYjao+bU+zxMgHw=";
  };

  npmDepsHash = "sha256-Fc5RbBqrJB7KSqLgTmIsPf3MK2n7vef/UVeFqH0o7mE=";

  dontNpmBuild = true;

  meta = {
    description = "GraphQL linter";
    homepage = "https://github.com/happylinks/gqlint";
    license = lib.licenses.mit;
    mainProgram = "gqlint";
    maintainers = with lib.maintainers; [ hardselius ];
  };
}
