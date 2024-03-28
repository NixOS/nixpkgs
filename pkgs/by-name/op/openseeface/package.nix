{ lib
, stdenvNoCC
, python3
, fetchFromGitHub
, makeWrapper
, enableVisualization ? false
}:

let
  python = python3.withPackages (ps: with ps; [
    (opencv4.override { enableGtk3 = enableVisualization; })
    onnxruntime
    pillow
    numpy
  ]);
in
stdenvNoCC.mkDerivation {
  pname = "openseeface";
  version = "1.20.4-unstable-2024-01-25";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "emilianavt";
    repo = "OpenSeeFace";
    rev = "ccbcae05c0acfb9da08115eb3df7f372cfabe7ff";
    hash = "sha256-wUMdOb0iQSRUAsEz47bvVFXsWWdnVzQNwvS8go8VUFA=";
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
