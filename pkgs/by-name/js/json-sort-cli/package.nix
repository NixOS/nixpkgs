{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
  nix-update-script,
}:

buildNpmPackage rec {
  pname = "json-sort-cli";
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "tillig";
    repo = "json-sort-cli";
    tag = "v${version}";
    hash = "sha256-jjI9uLAMFXD6s5AN5XYSps4p7Ke187aRwxNrGmz8eBk=";
  };

  npmDepsHash = "sha256-NS9o7XXybjUzPsjTAXw/+G4ffa1gY1ywt0pR4MDxNdQ=";
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
