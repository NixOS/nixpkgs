{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "json-sort-cli";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "tillig";
    repo = "json-sort-cli";
    tag = "v${version}";
    hash = "sha256-h7RlAFSb2pFolkd+0M5tddPxM5RgZJtNLLAoTuYNdIQ=";
  };

  npmDepsHash = "sha256-g+6yLvEnZ2Zi7+4M+KDVSL2Qf3COWGgiBtpYrwG4HRM=";
  dontNpmBuild = true;

  doCheck = true;
  checkPhase = ''
    runHook preCheck
    npm run test
    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI interface to json-stable-stringify.";
    homepage = "https://github.com/tillig/json-sort-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hasnep ];
    inherit (nodejs.meta) platforms;
    mainProgram = "json-sort";
  };
}
