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
  version = "1.0.0-unstable-2024-02-29";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "nixops-aws";
    rev = "d173b2f14ec767d782ceab45fb22b32fe3b5a1f7";
    hash = "sha256-ocTtc7POt1bugb9Bki2ew2Eh5uc933GftNw1twoOJsc=";
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

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
  };

  meta = with lib; {
    description = "AWS plugin for NixOps";
    homepage = "https://github.com/NixOS/nixops-aws";
    license = licenses.lgpl3Only;
    maintainers = nixops.meta.maintainers;
  };
}
