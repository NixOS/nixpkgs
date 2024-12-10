{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "reveal-md";
  version = "6.1.3";

  src = fetchFromGitHub {
    owner = "webpro";
    repo = "reveal-md";
    rev = version;
    hash = "sha256-m2aCC+ATymqKLn+aGEV8yzXASJJX4CI1YcPwt25T8k4=";
  };

  npmDepsHash = "sha256-QREJaF3aEHJA41fYTsJLlJU1l9bcVPS0BUkIzZIqZAA=";

  env = {
    PUPPETEER_SKIP_DOWNLOAD = true;
  };

  dontNpmBuild = true;

  doCheck = true;

  checkPhase = ''
    runHook preCheck

    npm run test

    runHook postCheck
  '';

  meta = {
    description = "Get beautiful reveal.js presentations from your Markdown files";
    mainProgram = "reveal-md";
    homepage = "https://github.com/webpro/reveal-md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sagikazarmark ];
  };
}
