{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  setuptools,
  pybind11,
  re2,
}:

buildPythonPackage rec {
  pname = "google-re2";
  version = "1.1.20240702";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "google_re2";
    inherit version;
    hash = "sha256-h4jbafbJPLIp32LHSy2aqOZL91TpSVcA+FgSr6Mu/Ss=";
  };

  build-system = [ setuptools ];

  buildInputs = [ re2 ];

  dependencies = [ pybind11 ];

  doCheck = false; # no tests in sdist

  pythonImportsCheck = [ "re2" ];

  meta = with lib; {
    description = "RE2 Python bindings";
    homepage = "https://github.com/google/re2";
    license = licenses.bsd3;
    maintainers = with maintainers; [ alexbakker ];
  };
}
