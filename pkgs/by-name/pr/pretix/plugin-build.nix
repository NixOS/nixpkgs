{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  django,
  gettext,
}:

buildPythonPackage rec {
  pname = "pretix-plugin-build";
  version = "1.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-iLbqcCAbeK4PyLXiebpdE27rt6bOP7eXczIG2bdvvYo=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    django
    gettext
  ];

  doCheck = false; # no tests

  meta = {
    description = "";
    homepage = "https://github.com/pretix/pretix-plugin-build";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
