{
  lib,
  python3,
  git,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "gato";
  version = "1.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "praetorian-inc";
    repo = "gato";
    tag = finalAttrs.version;
    hash = "sha256-h0MKEUH0INC227Z0APg4MU1U/b71MmtyUHtIVB+QcCA=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    colorama
    cryptography
    packaging
    py7zr
    pyyaml
    rarfile
    requests
    tqdm
  ];

  nativeCheckInputs = with python3.pkgs; [
    git
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "gato"
  ];

  meta = {
    description = "GitHub Self-Hosted Runner Enumeration and Attack Tool";
    homepage = "https://github.com/praetorian-inc/gato";
    changelog = "https://github.com/praetorian-inc/gato/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "gato";
  };
})
