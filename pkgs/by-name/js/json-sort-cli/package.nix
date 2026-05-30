{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "json-sort-cli";
  version = "3.0.1";

  src = fetchFromGitHub {
    owner = "tillig";
    repo = "json-sort-cli";
    tag = "v${version}";
    hash = "sha256-wUuVQmmcevGfcoYq5tPzEFRyPMMtbW/CeE5vNoCKFXQ=";
  };

  npmDepsHash = "sha256-4sjP3ri52CunwLcbIJF6+qGgciiPmZKsrLnm50HX0PQ=";
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
