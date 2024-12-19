{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "opencommit";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "di-sukharev";
    repo = "opencommit";
    rev = "v${version}";
    hash = "sha256-+uKb7qhQJEbuatPsewSGgVd5J6WtsrNO+hE59/KZIJI=";
  };

  npmDepsHash = "sha256-6tzV4iP7YzlbqOTgYf9XoTmIFPSBug0wYDelc6wcbCA=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "AI-powered commit message generator";
    homepage = "https://www.npmjs.com/package/opencommit";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.matteopacini ];
    mainProgram = "oco";
  };

}
