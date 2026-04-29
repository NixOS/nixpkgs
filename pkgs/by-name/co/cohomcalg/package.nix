{
  fetchFromGitHub,
  lib,
  stdenv,

  memtailor,
}:
let
  version = "0.32";
in
stdenv.mkDerivation {
  pname = "cohomcalg";
  version = version;

  src = fetchFromGitHub {
    owner = "BenjaminJurke";
    repo = "cohomCalg";
    rev = "refs/tags/v${version}";
    hash = "sha256-9kKKfb8STiCjaHiWgYEQsERNTnOXlwN8axIBJHg43zk=";
  };

  buildInputs = [
    memtailor
  ];

  enableParallelBuilding = true;

  checkTarget = "checkdirs";

  installPhase = ''
    mkdir -p $out
    mv bin $out/bin
  '';

  meta = {
    description = "Software package for computation of sheaf cohomologies for line bundles on toric varieties";
    homepage = "https://github.com/BenjaminJurke/cohomCalg";
    license = lib.licenses.gpl3Only;
  };
}
