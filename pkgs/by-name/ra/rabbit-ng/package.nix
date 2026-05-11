{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "rabbit-ng";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sgl-umons";
    repo = "RABBIT-ng";
    tag = finalAttrs.version;
    hash = "sha256-nd1LMJSJEUMMlKc4N7mQuEcBVJpGdQdZ6thmhk5BfCI=";
  };

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    ghmap
    numpy
    onnxruntime
    pandas
    python-dotenv
    requests
    typer
  ];

  pythonImportsCheck = [
    "rabbit_ng"
  ];

  meta = {
    description = "RABBIT is a machine-learning based tool designed to identify bot accounts among GitHub contributors";
    homepage = "https://github.com/sgl-umons/RABBIT-ng";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "rabbit-ng";
  };
})
