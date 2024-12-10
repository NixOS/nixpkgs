{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  unstableGitUpdater,
  poetry-core,
  libvirt,
  nixops,
}:

buildPythonPackage {
  pname = "nixops-libvirtd";
  version = "1.0.0-unstable-2023-09-01";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixops-libvirtd";
    rev = "b59424bf53e74200d684a4bce1ae64d276e793a0";
    hash = "sha256-HxJu8/hOPI5aCddTpna0mf+emESYN3ZxpTkitfKcfVQ=";
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
    libvirt
  ];

  pythonImportsCheck = [ "nixops_virtd" ];

  passthru.updateScript = unstableGitUpdater {
    tagPrefix = "v";
  };

  meta = with lib; {
    description = "NixOps libvirtd backend plugin";
    homepage = "https://github.com/nix-community/nixops-libvirtd";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ aminechikhaoui ];
    broken = true; # never built on Hydra
  };
}
