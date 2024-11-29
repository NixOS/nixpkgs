{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flask,
  flask-migrate,
  ldap3,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "automx2";
  version = "2024.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rseichter";
    repo = "automx2";
    rev = "refs/tags/${version}";
    hash = "sha256-7SbSKSjDHTppdqfPPKvuWbdoksHa6BMIOXOq0jDggTE=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    flask
    flask-migrate
    ldap3
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "automx2" ];

  meta = with lib; {
    description = "Email client configuration made easy";
    homepage = "https://rseichter.github.io/automx2/";
    changelog = "https://github.com/rseichter/automx2/blob/${version}/CHANGELOG";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ twey ];
  };
}
