{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "json-sort-cli";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "tillig";
    repo = "json-sort-cli";
    tag = "v${version}";
    hash = "sha256-KJCT1QwjXAmAlsLxAgNV7XXtpSytlCEbPTZYFoEZgww=";
  };

  npmDepsHash = "sha256-V+uKK3y3ImTHT6HSCmzlQUB+BqGYHyQyIB35uiIRNmg=";
  dontNpmBuild = true;

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    npm run test
    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI interface to json-stable-stringify";
    homepage = "https://github.com/tillig/json-sort-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hasnep ];
    inherit (nodejs.meta) platforms;
    mainProgram = "json-sort";
  };
}
