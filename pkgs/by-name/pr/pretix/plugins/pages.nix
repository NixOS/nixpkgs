{ lib
, buildPythonPackage
, fetchFromGitHub
, pretix-plugin-build
, setuptools
}:

buildPythonPackage rec {
  pname = "pretix-pages";
  version = "1.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretix";
    repo = "pretix-pages";
    rev = "v${version}";
    hash = "sha256-u2POt3v0OpjbauDCX8Uclvqd1+jujvVrzUIYrvDv/qI=";
  };

  build-system = [
    pretix-plugin-build
    setuptools
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [
    "pretix_pages"
  ];

  meta = with lib; {
    description = "Plugin to add static pages to your pretix event";
    homepage = "https://github.com/pretix/pretix-pages";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
