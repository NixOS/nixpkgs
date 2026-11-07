{
  lib,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "cpace";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "arturpragacz";
    repo = "cpace-py";
    tag = version;
    hash = "sha256-KHN5bKSk/BoblxLd3HLukq20+M+XgyzV0oST1mQtzTg=";
  };

  build-system = [ hatchling ];

  dependencies = [ cryptography ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cpace" ];

  meta = {
    description = "CPace balanced PAKE protocol implementation";
    homepage = "https://github.com/arturpragacz/cpace-py";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ SuperSandro2000 ];
  };
}
