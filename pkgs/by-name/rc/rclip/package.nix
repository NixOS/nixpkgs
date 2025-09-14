{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:
python3Packages.buildPythonApplication rec {
  pname = "rclip";
  version = "2.0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yurijmikhalevich";
    repo = "rclip";
    tag = "v${version}";
    hash = "sha256-OiAOK6i088TMqD2+PzdSs7UBsycNHa+nqWima0dPYIA=";
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
    "open_clip_torch"
    "pillow"
    "rawpy"
    "torch"
    "torchvision"
  ];

  pythonImportsCheck = [ "rclip" ];

  nativeCheckInputs = [
    versionCheckHook
  ]
  ++ (with python3Packages; [ pytestCheckHook ]);
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
