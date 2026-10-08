{
  lib,
  stdenv,
  python3Packages,
  fetchFromGitHub,
  fetchpatch,
  versionCheckHook,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "rclip";
  version = "3.3.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "yurijmikhalevich";
    repo = "rclip";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QdyqECPzZZtphtjSJAKrWGwGKcYrlbSSkJ0GHs9+K10=";
  };

  patches = [
    # use pillow-heif instead of pi-heif as it has been discontinued
    # https://github.com/bigcat88/pillow_heif/pull/431
    (fetchpatch {
      url = "https://github.com/yurijmikhalevich/rclip/commit/7207600d8da6aef0aacb2c2b52e90a564e3018aa.patch";
      hash = "sha256-Bua9tIpRq2mWSQLP0dcHE8S0Ef7AZKvlOS5fXAqTcQY=";
      revert = true;
    })
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.11.12,<0.12.0" uv_build
  '';

  build-system = with python3Packages; [
    uv-build
  ];

  pythonRelaxDeps = [
    "numpy"
    "pillow"
    "rawpy"
    "regex"
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
    tqdm
    rawpy
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
