{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "mini-graph-card";
  version = "0.13.0-dev.2";

  src = fetchFromGitHub {
    owner = "kalkih";
    repo = "mini-graph-card";
    tag = "v${version}";
    hash = "sha256-JpteGI9oR2twCTvEQ8xtb55EGQw//9EVuELh4BG0BE0=";
  };

  npmDepsHash = "sha256-Mg58i0L1e1YwBd81WwVgB56P7EYaq3FnMysIrgu0+qQ=";

  installPhase = ''
    runHook preInstall

    mkdir $out
    cp -v dist/mini-graph-card-bundle.js $out/

    runHook postInstall
  '';

  passthru.entrypoint = "mini-graph-card-bundle.js";

  meta = with lib; {
    changelog = "https://github.com/kalkih/mini-graph-card/releases/tag/v${version}";
    description = "Minimalistic graph card for Home Assistant Lovelace UI";
    homepage = "https://github.com/kalkih/mini-graph-card";
    maintainers = with maintainers; [ hexa ];
    license = licenses.mit;
  };
}
