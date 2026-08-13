{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pretix-plugin-build,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pretix-mollie";
  version = "2.5.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretix";
    repo = "pretix-mollie";
    tag = "v${version}";
    hash = "sha256-92nlq5EGI/AQ5RxDK1go/p4ZMtTDtzTFlWXsnVPvsg0=";
  };

  build-system = [
    pretix-plugin-build
    setuptools
  ];

  pythonImportsCheck = [
    "pretix_mollie"
  ];

  meta = {
    description = "Mollie payments for pretix";
    homepage = "https://github.com/pretix/pretix-mollie";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
