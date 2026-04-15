{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  npm-lockfile-fix,
}:

buildNpmPackage rec {
  pname = "opencommit";
  version = "3.2.18";

  src = fetchFromGitHub {
    owner = "di-sukharev";
    repo = "opencommit";
    rev = "v${version}";
    hash = "sha256-AhybkTAUojFPuw8RETGHoxDCWXcgb1zclfvh2h7bokM=";
    postFetch = ''
      cd $out
      # Fix lockfile issues with bundled dependencies
      ${lib.getExe npm-lockfile-fix} package-lock.json
    '';
  };

  npmDepsHash = "sha256-Kk0sPgxkWvbjGT8I3RDeniGN+8sQkwNYAXCTt009LbY=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "AI-powered commit message generator";
    homepage = "https://www.npmjs.com/package/opencommit";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.matteopacini ];
    mainProgram = "oco";
  };

}
