{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "newman";
  version = "6.2.3";

  src = fetchFromGitHub {
    owner = "postmanlabs";
    repo = "newman";
    tag = "v${version}";
    hash = "sha256-NGeECEJTgWsBh1jGOS3kA+HGBB85Gt5oIIXOjWX8/yE=";
  };

  npmDepsHash = "sha256-uigNqVJNfv+EW35+rgZi9CPDFJjBCvKTKLEGVeJi4HA=";

  dontNpmBuild = true;

  meta = {
    homepage = "https://www.getpostman.com";
    description = "Command-line collection runner for Postman";
    mainProgram = "newman";
    changelog = "https://github.com/postmanlabs/newman/releases/tag/v${version}";
    maintainers = [ ];
    license = lib.licenses.asl20;
  };
}
