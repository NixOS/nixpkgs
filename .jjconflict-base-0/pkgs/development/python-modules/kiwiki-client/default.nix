{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python-dateutil,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "kiwiki-client";
  version = "0.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "c7h";
    repo = "kiwiki_client";
    tag = version;
    hash = "sha256-CIBed8HzbUqUIzNy1lHxIgjneA6R8uKtmd43LU92M0Q=";
  };

  propagatedBuildInputs = [
    python-dateutil
    requests
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "kiwiki" ];

  meta = with lib; {
    description = "Module to interact with the KIWI.KI API";
    homepage = "https://github.com/c7h/kiwiki_client";
    changelog = "https://github.com/c7h/kiwiki_client/releases/tag/${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
