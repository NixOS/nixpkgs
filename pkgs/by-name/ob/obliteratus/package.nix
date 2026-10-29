{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "obliteratus";
  version = "0.1.2-unstable-2026-03-05";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "elder-plinius";
    repo = "OBLITERATUS";
    rev = "984ce140592a9385347934f9ca647413ba9fac76";
    hash = "sha256-U5DcRC1/IEQRlBGLIfsCX48ZCxPkpzEhg8qIw3ytJps=";
  };

  __structuredAttrs = true;

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    accelerate
    bitsandbytes
    datasets
    matplotlib
    numpy
    pandas
    pyyaml
    rich
    safetensors
    scikit-learn
    seaborn
    torch
    tqdm
    transformers
  ];

  optional-dependencies = with python3.pkgs; {
    spaces = [ gradio ];
  };

  nativeCheckInputs = with python3.pkgs; [
    pytest-cov-stub
    pytestCheckHook
  ];
  # This increases the build time significantly
  # ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "obliteratus" ];

  meta = {
    description = "Ablation Suite for HuggingFace transformers";
    homepage = "https://github.com/elder-plinius/OBLITERATUS";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "obliteratus";
  };
})
