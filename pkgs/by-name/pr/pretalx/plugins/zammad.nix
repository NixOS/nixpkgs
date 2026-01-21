{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  zammad-py,
}:

buildPythonPackage rec {
  pname = "pretalx-zammad";
  version = "2025.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "badbadc0ffee";
    repo = "pretalx-zammad";
    tag = "v${version}";
    hash = "sha256-YIKZO04vaKPGhUrTFiE4F+KjuBrYm0KsxUua5+Hm7gg=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    zammad-py
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [
    "pretalx_zammad"
  ];

  meta = {
    description = "Pretalx plugin for Zammad issue tracker";
    homepage = "https://github.com/badbadc0ffee/pretalx-zammad";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
