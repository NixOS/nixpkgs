{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  pretix-plugin-build,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pretix-servicefees";
  version = "1.15.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretix";
    repo = "pretix-servicefees";
    tag = "v${version}";
    hash = "sha256-gSxzZGokk498e9R8sPP3pVRkVvgjjHcvC8pxZFZHuU8=";
  };

  build-system = [
    django
    pretix-plugin-build
    setuptools
  ];

  postBuild = ''
    make
  '';

  doCheck = false; # no tests

  pythonImportsCheck = [ "pretix_servicefees" ];

  meta = {
    description = "Allows to charge a flat fee on all orders";
    homepage = "https://github.com/pretix/pretix-servicefees";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
