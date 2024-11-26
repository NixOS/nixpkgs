{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  setuptools-scm,
  django,
}:

buildPythonPackage rec {
  pname = "sorl-thumbnail";
  version = "12.11.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "sorl_thumbnail";
    inherit version;
    hash = "sha256-GRuJwn7LQLXCo1VJ1VfRfEhBxq/0ObLhe5OLke6kY7M=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  buildInputs = [ django ];

  env.DJANGO_SETTINGS_MODULE = "sorl.thumbnail.conf.defaults";

  # Disabled due to an improper configuration error when tested against django. This looks like something broken in the test cases for sorl.
  doCheck = false;

  pythonImportsCheck = [ "sorl.thumbnail" ];

  meta = with lib; {
    homepage = "https://sorl-thumbnail.readthedocs.org/en/latest/";
    description = "Thumbnails for Django";
    changelog = "https://github.com/jazzband/sorl-thumbnail/blob/${version}/CHANGES.rst";
    license = licenses.bsd3;
  };
}
