{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "opencommit";
  version = "3.2.7";

  src = fetchFromGitHub {
    owner = "di-sukharev";
    repo = "opencommit";
    rev = "v${version}";
    hash = "sha256-vmVOrNwUsgB3iBvO8QhpJfI2OO0Kb9ZthcAXVaQ2cBM=";
  };

  npmDepsHash = "sha256-F19xbiZoIC2JA+3rLqJBbFZvs2XbAk94F2borp/7gMo=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "AI-powered commit message generator";
    homepage = "https://www.npmjs.com/package/opencommit";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.matteopacini ];
    mainProgram = "oco";
  };

}
