{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:
python3Packages.buildPythonApplication rec {
  pname = "rclip";
  version = "2.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yurijmikhalevich";
    repo = "rclip";
    tag = "v${version}";
    hash = "sha256-d/jEtcBvOiebdI4DgWNWtP8ZfOy2x7EaQt/6mo7o2Ok=";
  };

  build-system = with python3Packages; [
    poetry-core
  ];

  dependencies = with python3Packages; [
    numpy
    open-clip-torch
    pillow
    requests
    torch
    torchvision
    tqdm
    rawpy
  ];

  pythonRelaxDeps = [
    "numpy"
    "pillow"
    "rawpy"
    "torch"
    "torchvision"
  ];

  pythonImportsCheck = [ "rclip" ];

  nativeCheckInputs = [
    versionCheckHook
  ] ++ (with python3Packages; [ pytestCheckHook ]);
  versionCheckProgramArg = "--version";

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

  meta = {
    description = "AI-Powered Command-Line Photo Search Tool";
    homepage = "https://github.com/yurijmikhalevich/rclip";
    changelog = "https://github.com/yurijmikhalevich/rclip/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iynaix ];
    mainProgram = "rclip";
  };
}
