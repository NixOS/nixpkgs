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
  version = "1.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretix";
    repo = "pretix-servicefees";
    tag = "v${version}";
    hash = "sha256-PsVItCBFJ4dRdRY2jKJ7aErYx/bhxKQtDsiJbyXsNKk=";
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

  meta = with lib; {
    description = "Allows to charge a flat fee on all orders";
    homepage = "https://github.com/pretix/pretix-servicefees";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
