{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  ldap3,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "sectools";
  version = "1.4.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "p0dalirius";
    repo = "sectools";
    rev = "refs/tags/${version}";
    hash = "sha256-k3k1/DFmv0resnsNht/C+2Xh6qbSQmk83eN/3vtDU00=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ ldap3 ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "sectools" ];

  meta = with lib; {
    description = "library containing functions to write security tools";
    homepage = "https://github.com/p0dalirius/sectools";
    changelog = "https://github.com/p0dalirius/sectools/releases/tag/${version}";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
