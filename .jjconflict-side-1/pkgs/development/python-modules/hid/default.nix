{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  hidapi,
}:

buildPythonPackage rec {
  pname = "hid";
  version = "1.0.7";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-P4CeKSq1LEQ1rRRCyO8gW+TJyk7rgPtHx9mODHVSeyo=";
  };

  postPatch = ''
    hidapi=${hidapi}/lib/
    test -d $hidapi || { echo "ERROR: $hidapi doesn't exist, please update/fix this build expression."; exit 1; }
    sed -i -e "s|libhidapi|$hidapi/libhidapi|" hid/__init__.py
  '';

  build-system = [ setuptools ];

  dependencies = [ hidapi ];

  doCheck = false; # no tests

  pythonImportsCheck = [ "hid" ];

  meta = with lib; {
    description = "hidapi bindings in ctypes";
    homepage = "https://github.com/apmorton/pyhidapi";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ];
  };
}
