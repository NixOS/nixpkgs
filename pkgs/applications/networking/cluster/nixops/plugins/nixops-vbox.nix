{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  unstableGitUpdater,
  poetry-core,
  nixops,
}:

buildPythonPackage {
  pname = "nixops-vbox";
  version = "1.0.0-unstable-2023-08-10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixops-vbox";
    rev = "baa5f09c9ae9aaf639c95192460ab5dcbe83a883";
    hash = "sha256-QrxherQO1t0VpYjJSEbntUWVD6GW4MtVHiKINpzHA1M=";
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

  pythonImportsCheck = [ "nixopsvbox" ];

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
  };

  meta = with lib; {
    description = "NixOps plugin for VirtualBox VMs";
    homepage = "https://github.com/nix-community/nixops-vbox";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ aminechikhaoui ];
  };
}
