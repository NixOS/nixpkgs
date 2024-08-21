{ lib
, stdenv
, python3
, fetchFromGitHub
, pkgs
}:

python3.pkgs.buildPythonApplication rec {
  pname = "deface";
  version = "1.5.0";
  pyproject = true;

  disabled = python3.pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ORB-HD";
    repo = "deface";
    rev = "refs/tags/v${version}";
    hash = "sha256-/mXWeL6OSgW4BMXtAZD/3UxQUGt7UE5ZvH8CXNCueJo=";
  };

  build-system = with python3.pkgs; [
    setuptools-scm
  ];

  dependencies = with python3.pkgs; [
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

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "opencv-python" "opencv"
  '';

  pythonImportsCheck = [ "deface" "onnx" "onnxruntime" ];

  meta = {
    description = "Video anonymization by face detection";
    homepage = "https://github.com/ORB-HD/deface";
    changelog = "https://github.com/ORB-HD/deface/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lurkki ];
    mainProgram = "deface";
    # terminate called after throwing an instance of 'onnxruntime::OnnxRuntimeException'
    broken = stdenv.hostPlatform.system == "aarch64-linux";
  };
}
