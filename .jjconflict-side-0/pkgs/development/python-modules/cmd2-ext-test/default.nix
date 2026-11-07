{
  lib,
  buildPythonPackage,
  cmd2,
  fetchPypi,
  pytestCheckHook,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "cmd2-ext-test";
  version = "2.0.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uTc+onurLilwQe0trESR3JGa5WFT1fCt3rRA7rhRpaY=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [ cmd2 ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "cmd2_ext_test" ];

  meta = {
    description = "Plugin supports testing of a cmd2 application";
    homepage = "https://github.com/python-cmd2/cmd2/tree/master/plugins/ext_test";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
