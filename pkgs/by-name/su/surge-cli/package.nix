{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

buildNpmPackage rec {
  pname = "surge-cli";
  version = "0.57.1";

  src = fetchFromGitHub {
    owner = "sintaxi";
    repo = "surge";
    rev = "v${version}";
    hash = "sha256-F/qIPMQlJRMW1DrRMwYrW5v/8+DjXB5TF2CBerXsN/A=";
  };

  npmDepsHash = "sha256-tzPLkkkiiM4N+3TC6aKjeaufrWWPtEhNYnPpGK+IfFU=";

  dontNpmBuild = true;

  meta = {
    mainProgram = "surge";
    description = "CLI for the surge.sh CDN";
    homepage = "https://surge.sh";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ MoritzBoehme ];
  };
}
