{
  lib,
  python3,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "qbom";
  version = "0.1.0-unstable-2026-01-21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "csnp";
    repo = "qbom";
    rev = "817414c311faac8da99042be82d9449019a8e9f9";
    hash = "sha256-qTcNoQZkcTaHQyZ0Lqbt1XlXsV15+tOcv7f+K7ydqmw=";
  };

  build-system = with python3.pkgs; [ hatchling ];

  dependencies = with python3.pkgs; [
    click
    pydantic
    rich
    xxhash
  ];

  optional-dependencies = with python3.pkgs; {
    all = [
      cirq
      pennylane
      qiskit
    ];
    cirq = [ cirq ];
    pennylane = [ pennylane ];
    qiskit = [ qiskit ];
  };

  nativeCheckInputs = with python3.pkgs; [
    pytest-cov-stub
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "qbom" ];

  meta = {
    description = "Quantum Bill of Materials (QBOM) tool";
    homepage = "https://github.com/csnp/qbom";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "qbom";
  };
})
