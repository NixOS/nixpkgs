{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "jsonld-cli";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "digitalbazaar";
    repo = "jsonld-cli";
    rev = "v${version}";
    hash = "sha256-GandTCcRYd0c0SlSdsCAcaTKfwD4g1cwHuoxA62aD74=";
  };

  postPatch = "cp ${./package-lock.json} package-lock.json";
  npmDepsHash = "sha256-6oQKHeX5P2UsXRFK7ZwmJYasuNT5Ch/bYCIUAXq5zUM=";
  dontNpmBuild = true;

  meta = {
    description = "JSON-LD command line interface tool";
    homepage = "https://github.com/digitalbazaar/jsonld-cli";
    changelog = "https://github.com/digitalbazaar/jsonld-cli/blob/main/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ msladecek ];
    mainProgram = "jsonld";
  };
}
