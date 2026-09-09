{
  lib,
  python3,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "qbom";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "csnp";
    repo = "qbom";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mYxP9RZB92i6qszWkXnLb+jRpT1G1g+Ea1lD770otIA=";
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
    jsonschema
    pytest-cov-stub
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "qbom" ];

  meta = {
    description = "Quantum Bill of Materials (QBOM) tool";
    homepage = "https://github.com/csnp/qbom";
    changelog = "https://github.com/csnp/qbom/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "qbom";
  };
})
