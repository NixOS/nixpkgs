{
  lib,
  bitarray,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  wheel,
  xxhash,
}:

buildPythonPackage rec {
  pname = "pybloom-live";
  version = "4.0.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "pybloom_live";
    inherit version;
    hash = "sha256-mVRcXTsFvTiLVJHja4I7cGgwpoa6GLTBkGPQjeUyERA=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    bitarray
    xxhash
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pybloom_live" ];

  meta = with lib; {
    description = "Probabilistic data structure";
    homepage = "https://github.com/joseph-fox/python-bloomfilter";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
