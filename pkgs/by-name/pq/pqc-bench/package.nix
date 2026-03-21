{
  lib,
  python3,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "pqc-bench";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "csnp";
    repo = "pqc-bench";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9f4BJ7TM7hpZ4Z8TGwvo4t8Rlgx2u9U7xsE+5aCxWI8=";
  };

  build-system = with python3.pkgs; [ hatchling ];

  dependencies = with python3.pkgs; [
    rich
    typer
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytest-cov-stub
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "pqc_bench" ];

  meta = {
    description = "Post-Quantum Cryptography Recommendation Engine";
    homepage = "https://github.com/csnp/pqc-bench";
    changelog = "https://github.com/csnp/pqc-bench/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pqc-bench";
  };
})
