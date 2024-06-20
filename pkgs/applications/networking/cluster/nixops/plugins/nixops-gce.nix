{ lib
, buildPythonPackage
, fetchFromGitHub
, unstableGitUpdater
, poetry-core
, cryptography
, libcloud
, nixops
, nixos-modules-contrib
}:

buildPythonPackage {
  pname = "nixops-gce";
  version = "0-unstable-2023-05-26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixops-gce";
    rev = "d13cb794aef763338f544010ceb1816fe31d7f42";
    hash = "sha256-UkYf6CoUrr8yuQoe/ik6vu+UCi3ByJd0BdkS9SLEp0Q=";
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
    cryptography
    libcloud
    nixos-modules-contrib
  ];

  pythonImportsCheck = [ "nixops_gcp" ];

  passthru.updateScript = unstableGitUpdater {};

  meta = with lib; {
    description = "NixOps Google Cloud Backend";
    homepage = "https://github.com/nix-community/nixops-gce";
    license = licenses.mit;
    maintainers = nixops.meta.maintainers;
    broken = true; # never built on Hydra
  };
}
