{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  qmk,
}:
stdenvNoCC.mkDerivation {
  pname = "qmk-avr";
  version = "none";

  src = fetchFromGitHub {
    owner = "qmk";
    repo = "qmk_firmware";
    tag = "0.33.13";
    fetchSubmodules = true;
    hash = "sha256-FDN+pQrgdKqleku5L6xViajY1jEkjZZX5ZGx46N8dkw=";
  };

  nativeBuildInputs = [
    qmk
  ];

  buildPhase = ''
    qmk compile -kb bpiphany/pegasushoof -km default -e VERBOSE=true -e SKIP_GIT=true -e LTO_ENABLE=true
  '';

  installPhase = ''
    mkdir "$out"
    cp .build/*.hex "$out"
  '';
}
