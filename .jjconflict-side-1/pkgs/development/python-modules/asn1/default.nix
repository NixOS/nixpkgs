{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "asn1";
  version = "3.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "andrivet";
    repo = "python-asn1";
    tag = "v${version}";
    hash = "sha256-OVDhA5ClnwJJwZw0oinAUUDBN/s2ECgHXEww+8hB/fQ=";
  };

  build-system = [ setuptools ];

  pythonRemoveDeps = [ "enum-compat" ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "tests/test_asn1.py" ];

  pythonImportsCheck = [ "asn1" ];

  meta = with lib; {
    description = "Python ASN.1 encoder and decoder";
    homepage = "https://github.com/andrivet/python-asn1";
    changelog = "https://github.com/andrivet/python-asn1/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
