{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
}:

buildNpmPackage rec {
  pname = "surge-cli";
  version = "0.23.1";

  src = fetchFromGitHub {
    owner = "sintaxi";
    repo = "surge";
    rev = "v${version}";
    hash = "sha256-EpYww/YCQhPFmnOJ1zbigI2qyUrKN2TxKHEju/0Si3M=";
  };

  npmDepsHash = "sha256-F1C/sfOT/Tf+h28g1umP6czLFIsxDkbvT14ZfWLTiCE=";

  dontNpmBuild = true;

  meta = with lib; {
    mainProgram = "surge";
    description = "CLI for the surge.sh CDN";
    homepage = "https://surge.sh";
    license = licenses.mit;
    maintainers = with maintainers; [ MoritzBoehme ];
  };
}
