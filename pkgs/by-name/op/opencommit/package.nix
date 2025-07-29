{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  npm-lockfile-fix,
}:

buildNpmPackage rec {
  pname = "opencommit";
  version = "3.2.9";

  src = fetchFromGitHub {
    owner = "di-sukharev";
    repo = "opencommit";
    rev = "v${version}";
    hash = "sha256-nn+Whjs3qLXhydrELXzogr66H6btY/TPbmWT/MH6w+M=";
    postFetch = ''
      cd $out
      # Fix lockfile issues with bundled dependencies
      ${lib.getExe npm-lockfile-fix} package-lock.json
    '';
  };

  npmDepsHash = "sha256-1lUMtQFGlM1Z2oQ4nktsePyce/EwAu75BbkBiqBrdnQ=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "AI-powered commit message generator";
    homepage = "https://www.npmjs.com/package/opencommit";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.matteopacini ];
    mainProgram = "oco";
  };

}
