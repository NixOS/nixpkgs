{
  lib,
  python314,
  fetchFromGitHub,
}:

python314.pkgs.buildPythonApplication (finalAttrs: {
  pname = "shinestacker";
  version = "1.16.2";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lucalista";
    repo = "shinestacker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Rm9Mmn0k95kwtLy26iiz3mmRYs3c2ir3WUawrzr+2P4=";
  };

  build-system = with python314.pkgs; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python314.pkgs; [
    imagecodecs
    ipywidgets
    jsonpickle
    matplotlib
    numpy
    opencv-python-headless
    pillow
    psdtags
    psutil
    pyside6
    rawpy
    scipy
    tifffile
    tqdm
  ];

  pythonImportsCheck = [
    "shinestacker"
  ];

  nativeCheckInputs = with python314.pkgs; [ pytestCheckHook ];

  disabledTestPaths = [
    "tests/test_1020_gui_images.py"
    "tests/test_1030_gui_logging.py"
    "tests/test_1040_action_config.py"
    "tests/test_1060_gui_run.py"
    "tests/test_0004_app_config.py"
    "tests/test_0090_vignetting.py"
    "tests/test_0040_balance.py"
    "tests/test_0030_align.py"
    "tests/test_0020_noise_detection.py"
  ];

  meta = {
    description = "Focus stacking code";
    homepage = "https://github.com/lucalista/shinestacker";
    changelog = "https://github.com/lucalista/shinestacker/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ paperdigits ];
    mainProgram = "shinestacker";
  };
})
