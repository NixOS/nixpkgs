{
  lib,
  stdenvNoCC,
  python3,
  fetchFromGitHub,
  makeWrapper,
  enableVisualization ? false,
}:

let
  python = python3.withPackages (
    ps: with ps; [
      (opencv4.override { enableGtk3 = enableVisualization; })
      onnxruntime
      pillow
      numpy
    ]
  );
in
stdenvNoCC.mkDerivation {
  pname = "openseeface";
  version = "1.20.4-unstable-2024-09-21";

  src = fetchFromGitHub {
    owner = "emilianavt";
    repo = "OpenSeeFace";
    rev = "e6e24efd2038ab778ac094bab21c2c18a7efbeb2";
    hash = "sha256-pSZXD6UiKPd8sTagdA/I6bI8nWdF1c6SX2Bho+X7pX8=";
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/openseeface
    cp -r *.py models $out/share/openseeface

    makeWrapper ${python.interpreter} "$out/bin/facetracker" \
        --add-flags "$out/share/openseeface/facetracker.py"

    runHook postInstall
  '';

  meta = {
    description = "Robust realtime face and facial landmark tracking on CPU with Unity integration";
    homepage = "https://github.com/emilianavt/OpenSeeFace";
    license = lib.licenses.bsd2;
    mainProgram = "facetracker";
    maintainers = with lib.maintainers; [ tomasajt ];
  };
}
