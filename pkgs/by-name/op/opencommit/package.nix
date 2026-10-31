{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  npm-lockfile-fix,
}:

buildNpmPackage rec {
  pname = "opencommit";
  version = "3.3.11";

  src = fetchFromGitHub {
    owner = "di-sukharev";
    repo = "opencommit";
    rev = "v${version}";
    hash = "sha256-wYwZlqItbjNjdScvPIx8/8ND3FTRsXwwu6e2WI19HcU=";
    postFetch = ''
      cd $out
      # Fix lockfile issues with bundled dependencies
      ${lib.getExe npm-lockfile-fix} package-lock.json
    '';
  };

  npmDepsHash = "sha256-ID7xdL6loDYsCYzQgLp5daTYsIEyJQGK1VoKIZjlxgU=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "AI-powered commit message generator";
    homepage = "https://www.npmjs.com/package/opencommit";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.matteopacini ];
    mainProgram = "oco";
  };

}
