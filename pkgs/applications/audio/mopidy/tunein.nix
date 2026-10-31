{
  lib,
  pythonPackages,
  fetchPypi,
  mopidy,
}:

pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "mopidy-tunein";
  version = "2.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "mopidy_tunein";
    hash = "sha256-90aDymPH1ZhS8ks2Ya+jEwP9vcGvXRFVKfxAA+T9R6M=";
  };

  build-system = [
    pythonPackages.setuptools
    pythonPackages.setuptools-scm
  ];

  dependencies = [
    mopidy
    pythonPackages.httpx
    pythonPackages.pykka
  ];

  nativeCheckInputs = [
    pythonPackages.pytestCheckHook
    pythonPackages.pytest-httpx
  ];

  pythonImportsCheck = [ "mopidy_tunein.tunein" ];

  meta = {
    description = "Mopidy extension for playing music from tunein";
    homepage = "https://github.com/mopidy/mopidy-tunein";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
