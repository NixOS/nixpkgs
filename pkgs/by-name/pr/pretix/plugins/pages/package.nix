{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pretix-plugin-build,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pretix-pages";
  version = "1.6.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretix";
    repo = "pretix-pages";
    rev = "v${version}";
    hash = "sha256-whpO8aE0VUSrByf3P0JaIoruYbJi8wj4nZo/2tx+XLU=";
  };

  build-system = [
    pretix-plugin-build
    setuptools
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [
    "pretix_pages"
  ];

  meta = {
    description = "Plugin to add static pages to your pretix event";
    homepage = "https://github.com/pretix/pretix-pages";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
