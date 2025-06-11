{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "json-sort-cli";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "tillig";
    repo = "json-sort-cli";
    tag = "v${version}";
    hash = "sha256-0NiDrZM00B3GcG+bH40QJZFXBFzY+4r1E1w1NbhiqUE=";
  };

  npmDepsHash = "sha256-UGy1+AfIWQTCP38E1w7I8PTc7Bsh/2gV5wNmfCvIau8=";
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
