{
  lib,
  mopidy,
  pythonPackages,
  fetchPypi,
}:

pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "mopidy-local";
  version = "4.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "mopidy_local";
    hash = "sha256-C+zGi81jfzmo6J9izaSJ/rdjVCeQZcNnPR+/agvrVwg=";
  };

  build-system = [
    pythonPackages.setuptools
    pythonPackages.setuptools-scm
  ];

  dependencies = [
    mopidy
    pythonPackages.uritools
  ];

  nativeCheckInputs = [
    pythonPackages.pytestCheckHook
  ];

  pythonImportsCheck = [ "mopidy_local" ];

  meta = {
    homepage = "https://github.com/mopidy/mopidy-local";
    description = "Mopidy extension for playing music from your local music archive";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ruuda ];
  };
})
