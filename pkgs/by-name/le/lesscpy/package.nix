{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonPackage rec {
  pname = "lesscpy";
  version = "0.15.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-EEXRepj2iGRsp1jf8lTm6cA3RWSOBRoIGwOVw7d8gkw=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    ply
    six
  ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  pythonImportsCheck = [ "lesscpy" ];

  meta = with lib; {
    description = "Python LESS Compiler";
    mainProgram = "lesscpy";
    homepage = "https://github.com/lesscpy/lesscpy";
    license = licenses.mit;
    maintainers = with maintainers; [ s1341 ];
  };
}
