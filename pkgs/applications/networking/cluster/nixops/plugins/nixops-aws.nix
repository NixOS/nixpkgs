{ lib
, buildPythonPackage
, fetchFromGitHub
, unstableGitUpdater
, poetry-core
, boto
, boto3
, nixops
, nixos-modules-contrib
, typing-extensions
}:

buildPythonPackage {
  pname = "nixops-aws";
  version = "unstable-2023-08-09";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "nixops-aws";
    rev = "8802d1cda9004ec1362815292c2a8ab95e6d64e8";
    hash = "sha256-i0KjFrwpDHRch9jorccdVwnjAQiORClDUqm2R2xvwuU=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
    --replace poetry.masonry.api poetry.core.masonry.api \
    --replace "poetry>=" "poetry-core>="
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  buildInputs = [
    nixops
  ];

  propagatedBuildInputs = [
    boto
    boto3
    nixos-modules-contrib
    typing-extensions
  ];

  pythonImportsCheck = [ "nixops_aws" ];

  passthru.updateScript = unstableGitUpdater {};

  meta = with lib; {
    description = "AWS plugin for NixOps";
    homepage = "https://github.com/NixOS/nixops-aws";
    license = licenses.lgpl3Only;
    maintainers = nixops.meta.maintainers;
  };
}
