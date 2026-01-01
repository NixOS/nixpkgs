{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "soco-cli";
<<<<<<< HEAD
  version = "0.4.82";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "avantrec";
    repo = "soco-cli";
    tag = "v${version}";
    hash = "sha256-kD+78dNQ/dff8y9/A3qdIrARStkal3Eu7/plG0T1CrQ=";
=======
  version = "0.4.80";
  pyproject = true;

  disabled = python3.pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "avantrec";
    repo = "soco-cli";
    rev = "v${version}";
    hash = "sha256-w4F1N1ULGH7mbxtI8FpZ54ixa9o7N2A9OEiE2FOf73g=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    fastapi
    rangehttpserver
    soco
    tabulate
    uvicorn
  ];

  # Tests wants to communicate with hardware
  doCheck = false;

<<<<<<< HEAD
  pythonImportsCheck = [ "soco_cli" ];
=======
  pythonImportsCheck = [
    "soco_cli"
  ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "Command-line interface to control Sonos sound systems";
    homepage = "https://github.com/avantrec/soco-cli";
<<<<<<< HEAD
    changelog = "https://github.com/avantrec/soco-cli/blob/${src.tag}/CHANGELOG.txt";
    license = lib.licenses.asl20;
=======
    license = with lib.licenses; [ asl20 ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "sonos";
    maintainers = with lib.maintainers; [ fab ];
  };
}
