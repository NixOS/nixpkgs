{ lib
, python3Packages
, fetchFromGitHub
}:
python3Packages.buildPythonApplication rec {
  pname = "rclip";
  version = "1.7.24";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yurijmikhalevich";
    repo = "rclip";
    rev = "v${version}";
    hash = "sha256-JWtKgvSP7oaPg19vWnnCDfm7P5Uew+v9yuvH7y2eHHM=";
  };

  nativeBuildInputs = with python3Packages; [
    poetry-core
  ];

  propagatedBuildInputs = with python3Packages; [
    open-clip-torch
    pillow
    requests
    torch
    torchvision
    tqdm
  ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook pythonRelaxDepsHook ];

  pythonRelaxDeps = [ "torch" "torchvision" ];

  pythonImportsCheck = [ "rclip" ];

  disabledTestPaths = [
    # requires network
    "tests/e2e/test_rclip.py"
  ];

  meta = with lib; {
    description = "AI-Powered Command-Line Photo Search Tool";
    homepage = "https://github.com/yurijmikhalevich/rclip";
    license = licenses.mit;
    maintainers = with maintainers; [ iynaix ];
    mainProgram = "rclip";
  };
}
