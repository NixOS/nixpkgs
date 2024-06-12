{ lib
, python3Packages
, fetchFromGitHub
}:
python3Packages.buildPythonApplication rec {
  pname = "rclip";
  version = "1.8.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yurijmikhalevich";
    repo = "rclip";
    rev = "refs/tags/v${version}";
    hash = "sha256-wjwi6GBblv8Z3SA1bMrtPz3KVF8Zw5595Hqyp8FPgcg=";
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
