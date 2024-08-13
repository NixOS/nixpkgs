{ lib
, buildPythonPackage
, fetchFromGitHub
, substituteAll

# build-system
, pretix-plugin-build
, setuptools

# runtime
, openssl

# dependencies
, googlemaps
, wallet-py3k
}:

buildPythonPackage rec {
  pname = "pretix-passbook";
  version = "1.13.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pretix";
    repo = "pretix-passbook";
    rev = "v${version}";
    hash = "sha256-bp64wCEMon05JhOaDr/cVbqUxc+7ndcsSuSesxJt8GE=";
  };

  patches = [
    (substituteAll {
      src = ./passbook-openssl.patch;
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
