{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
  npm-lockfile-fix,
}:

buildNpmPackage rec {
  pname = "opencommit";
  version = "3.3.5";

  src = fetchFromGitHub {
    owner = "di-sukharev";
    repo = "opencommit";
    rev = "v${version}";
    hash = "sha256-aLm4tb9uF3Jh9xSrW1qiQZihS90yX9EUQfckmjkTnMQ=";
    postFetch = ''
      cd $out
      # Fix lockfile issues with bundled dependencies
      ${lib.getExe npm-lockfile-fix} package-lock.json
    '';
  };

  npmDepsHash = "sha256-sjKkKq4D0DEnKqajQxY9iN3Q+E3nVUpSHCS8uCStb3c=";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "AI-powered commit message generator";
    homepage = "https://www.npmjs.com/package/opencommit";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.matteopacini ];
    mainProgram = "oco";
  };

}
