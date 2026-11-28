{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

buildNpmPackage rec {
  pname = "surge-cli";
  version = "0.58.0";

  src = fetchFromGitHub {
    owner = "sintaxi";
    repo = "surge";
    rev = "v${version}";
    hash = "sha256-6R4W+8qqelGrGp/wJp+KkSo2HYQXu0OBQjpgjOXPLe4=";
  };

  npmDepsHash = "sha256-m2+Ny6qBVoyMs7ys+MD9vs7VHpL/B+j+5gDM8hixsbg=";

  dontNpmBuild = true;

  meta = {
    mainProgram = "surge";
    description = "CLI for the surge.sh CDN";
    homepage = "https://surge.sh";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ MoritzBoehme ];
  };
}
