{ lib
, stdenv
, python3
, fetchFromGitHub
, makeWrapper
, pkgs
}:

python3.pkgs.buildPythonApplication rec {
  pname = "deface";
  version = "1.4.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "ORB-HD";
    repo = "deface";
    rev = "v${version}";
    hash = "sha256-tLNTgdnKKmyYHVajz0dHIb7cvC1by5LQ5CFIbMvPEYk=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools-scm
  ];

  propagatedBuildInputs = with python3.pkgs; [
    imageio
    imageio-ffmpeg
    numpy
    onnx
    onnxruntime # Nixpkgs onnxruntime is missing CUDA support
    opencv4
    scikit-image
    tqdm
  ];

  # Native onnxruntime lib used by Python module onnxruntime can't find its other libs without this
  makeWrapperArgs = [
    ''--prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath [ pkgs.onnxruntime ]}"''
  ];

  patchPhase = ''
    substituteInPlace pyproject.toml requirements.txt --replace "opencv-python" "opencv"
  '';

  # Let setuptools know deface version
  SETUPTOOLS_SCM_PRETEND_VERSION = "v${version}";

  pythonImportsCheck = [ "deface" "onnx" "onnxruntime" ];

  meta = with lib; {
    description = "Video anonymization by face detection";
    homepage = "https://github.com/ORB-HD/deface";
    license = licenses.mit;
    maintainers = with maintainers; [ lurkki ];
    mainProgram = "deface";
  };
}
