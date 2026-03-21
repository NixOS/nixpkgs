{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  npm-lockfile-fix,
}:

buildNpmPackage rec {
  pname = "opencommit";
  version = "3.2.14";

  src = fetchFromGitHub {
    owner = "di-sukharev";
    repo = "opencommit";
    rev = "v${version}";
    hash = "sha256-FA4ER8UDxDy/KcGgUu4xqjQnV17ouKt/QWUcrwjtb/s=";
    postFetch = ''
      cd $out
      # Fix lockfile issues with bundled dependencies
      ${lib.getExe npm-lockfile-fix} package-lock.json
    '';
  };

  npmDepsHash = "sha256-gxjJoodnKE08bhOnA5r6A0UQg8ElB693Vm2BVrA2Z0k=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "AI-powered commit message generator";
    homepage = "https://www.npmjs.com/package/opencommit";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.matteopacini ];
    mainProgram = "oco";
  };

}
