{ lib
, python3Packages
, fetchFromGitHub
}:
python3Packages.buildPythonApplication rec {
  pname = "rclip";
  version = "1.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yurijmikhalevich";
    repo = "rclip";
    rev = "refs/tags/v${version}";
    hash = "sha256-l3KsOX5IkU4/wQyXXHR+09KPSD6nsnBaiGjSi7fMyqA=";
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

  disabledTests = [
    # requires network
    "test_text_model_produces_the_same_vector_as_the_main_model"
    "test_loads_text_model_when_text_processing_only_requested_and_checkpoint_exists"
    "test_loads_full_model_when_text_processing_only_requested_and_checkpoint_doesnt_exist"
  ];

  meta = with lib; {
    description = "AI-Powered Command-Line Photo Search Tool";
    homepage = "https://github.com/yurijmikhalevich/rclip";
    license = licenses.mit;
    maintainers = with maintainers; [ iynaix ];
    mainProgram = "rclip";
  };
}
