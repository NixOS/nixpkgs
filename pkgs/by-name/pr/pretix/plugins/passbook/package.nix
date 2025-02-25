{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  replaceVars,

  # build-system
  pretix-plugin-build,
  setuptools,

  # runtime
  openssl,

  # dependencies
  googlemaps,
  wallet-py3k,
}:

buildPythonPackage rec {
  pname = "pretix-passbook";
  version = "1.13.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretix";
    repo = "pretix-passbook";
    rev = "v${version}";
    hash = "sha256-xN37nM2AQVxFg+TOZ3cEvEV4F115U9m6YVX12al4SIw=";
  };

  patches = [
    (replaceVars ./openssl.patch {
      openssl = lib.getExe openssl;
    })
  ];

  build-system = [
    pretix-plugin-build
    setuptools
  ];

  dependencies = [
    googlemaps
    wallet-py3k
  ];

  doCheck = false; # no tests

  pythonImportsCheck = [
    "pretix_passbook"
  ];

  meta = with lib; {
    description = "Support for Apple Wallet/Passbook files in pretix";
    homepage = "https://github.com/pretix/pretix-passbook";
    license = licenses.asl20;
    maintainers = with maintainers; [ hexa ];
  };
}
