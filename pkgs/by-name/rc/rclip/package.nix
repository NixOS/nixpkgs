{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "rclip";
  version = "3.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "yurijmikhalevich";
    repo = "rclip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LiqhJNt6wSSmwJ6kQJQpIHXYjdQI9eR2rrqkYPZknrQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.11.12,<0.12.0" uv_build
  '';

  build-system = with python3Packages; [
    uv-build
  ];

  dependencies = with python3Packages; [
    ftfy
    huggingface-hub
    numpy
    onnxruntime
    pillow
    pillow-heif
    regex
    requests
    tqdm
    rawpy
  ];

  pythonRelaxDeps = [
    "numpy"
    "pillow"
    "rawpy"
  ];

  pythonImportsCheck = [ "rclip" ];

  nativeCheckInputs = [
    versionCheckHook
    python3Packages.jinja2
  ]
  ++ (with python3Packages; [ pytestCheckHook ]);

  disabledTestPaths = [
    # requires network
    "tests/e2e/test_rclip.py"
  ];

  meta = {
    description = "AI-Powered Command-Line Photo Search Tool";
    homepage = "https://github.com/yurijmikhalevich/rclip";
    changelog = "https://github.com/yurijmikhalevich/rclip/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ iynaix ];
    mainProgram = "rclip";
  };
})
