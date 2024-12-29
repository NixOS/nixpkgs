{ lib
, buildPythonPackage
, fetchFromGitHub
, unstableGitUpdater
, poetry-core
, nixops
, python-digitalocean
, pythonOlder
}:

buildPythonPackage {
  pname = "nixops-digitalocean";
  version = "0.1.0-unstable-2022-08-14";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixops-digitalocean";
    rev = "e977b7f11e264a6a2bff2dcbc7b94c6a97b92fff";
    hash = "sha256-aJtShvdqjAiCK5oZL0GR5cleDb4s1pJkO6UPKGd4Dgg=";
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
    python-digitalocean
  ];

  pythonImportsCheck = [ "nixops_digitalocean" ];

  passthru.updateScript = unstableGitUpdater {};

  meta = with lib; {
    description = "NixOps Digitalocean plugin";
    homepage = "https://github.com/nix-community/nixops-digitalocean";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ ];
  };
}
