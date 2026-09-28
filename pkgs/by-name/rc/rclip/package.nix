{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "rclip";
  version = "4.0.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "yurijmikhalevich";
    repo = "rclip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-JP3c/OZWXqOi6Y2shBes7A2kh5jcaRS6YSRVkdzMUYY=";
  };

  build-system = with python3Packages; [
    uv-build
  ];

  pythonRelaxDeps = [
    "numpy"
    "pillow"
    "rawpy"
    "regex"
    "textual-image"
  ];
  pythonRemoveDeps = lib.optionals stdenv.hostPlatform.isDarwin [
    # unpackaged
    "coremltools"
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
    textual
    textual-image
    tqdm
    rawpy
  ];

  pythonImportsCheck = [ "rclip" ];

  nativeCheckInputs = [
    versionCheckHook
    python3Packages.jinja2
  ]
  ++ (with python3Packages; [ pytestCheckHook ]);

  disabledTests = [
    # requires rawpy to be built with DEMOSAIC_PACK_GPL2
    "test_collects_native_versions_from_runtime_apis"
    # requires rclip to be built with uv before inspecting the artifacts
    "test_sdist_includes_compliance_inputs"
    "test_wheel_includes_clip_legal_files"
  ];

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
