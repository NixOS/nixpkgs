{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "haikuporter";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "haikuports";
    repo = "haikuporter";
    rev = version;
    hash = "sha256-/P5W6m76dkA4k12+8aoY3j4lu2TkFgANKKtX5QgLPaA=";
  };

  build-system = [
    python3.pkgs.poetry-core
  ];

  dependencies = with python3.pkgs; [
    black
    boto3
    isort
    pylint
  ];

  pythonRelaxDeps = [ "black" "pylint" ];

  nativeBuildInputs = [ python3.pkgs.pythonRelaxDepsHook ];

  pythonImportsCheck = [
    "HaikuPorter"
  ];

  meta = {
    description = "The tool that builds HaikuPorts recipes";
    homepage = "https://github.com/haikuports/haikuporter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthewcroughan ];
    mainProgram = "haikuporter";
  };
}
