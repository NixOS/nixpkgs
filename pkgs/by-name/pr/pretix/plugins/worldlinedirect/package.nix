{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pretix-plugin-build,
  setuptools,
  onlinepayments-sdk-python3,
}:

buildPythonPackage rec {
  pname = "pretix-worldlinedirect";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretix";
    repo = "pretix-worldlinedirect";
    rev = "v${version}";
    hash = "sha256-ofDGbRYTA2GTnVexn0dE6Iftq6+MkigOXWVR4kPUJzY=";
  };

  build-system = [
    pretix-plugin-build
    setuptools
  ];

  dependencies = [
    onlinepayments-sdk-python3
  ];

  pythonImportsCheck = [
    "pretix_payonegopay"
    "pretix_worldlinedirect"
  ];

  meta = {
    description = "A pretix plugin to accept payments through Worldline Direct";
    homepage = "https://github.com/pretix/pretix-worldlinedirect";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
