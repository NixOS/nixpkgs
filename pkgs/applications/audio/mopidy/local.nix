{
  lib,
  mopidy,
  pythonPackages,
  fetchPypi,
}:

pythonPackages.buildPythonApplication rec {
  pname = "mopidy-local";
  version = "3.3.0";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "mopidy_local";
    hash = "sha256-y6btbGk5UiVan178x7d9jq5OTnKMbuliHv0aRxuZK3o=";
  };

  build-system = [
    pythonPackages.setuptools
  ];

  dependencies = [
    mopidy
    pythonPackages.uritools
  ];

  nativeCheckInputs = [
    pythonPackages.pytestCheckHook
  ];

  pythonImportsCheck = [ "mopidy_local" ];

  meta = with lib; {
    homepage = "https://github.com/mopidy/mopidy-local";
    description = "Mopidy extension for playing music from your local music archive";
    license = licenses.asl20;
    maintainers = with maintainers; [ ruuda ];
  };
}
