{
  lib,
  buildPythonPackage,
  fetchPypi,
  attrs,
  pbr,
}:

buildPythonPackage rec {
  pname = "sarif-om";
  version = "1.0.4";
  format = "setuptools";

  src = fetchPypi {
    pname = "sarif_om";
    inherit version;
    sha256 = "cd5f416b3083e00d402a92e449a7ff67af46f11241073eea0461802a3b5aef98";
  };

  nativeBuildInputs = [ pbr ];

  propagatedBuildInputs = [ attrs ];

  pythonImportsCheck = [ "sarif_om" ];

  # no tests included with tarball
  doCheck = false;

  meta = with lib; {
    description = "Classes implementing the SARIF 2.1.0 object model";
    homepage = "https://github.com/microsoft/sarif-python-om";
    license = licenses.mit;
    maintainers = [ ];
  };
}
