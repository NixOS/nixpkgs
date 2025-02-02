{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  unstableGitUpdater,
  poetry-core,
  nixops,
}:

buildPythonPackage {
  pname = "nixops-encrypted-links";
  version = "0-unstable-2021-02-16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = "nixops-encrypted-links";
    rev = "e2f196fce15fcfb00d18c055e1ac53aec33b8fb1";
    hash = "sha256-1TTbARyCfrLxF6SVNkmIKNNcLS9FVW22d9w0VRrH1os=";
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

  pythonImportsCheck = [ "nixops_encrypted_links" ];

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "EncryptedLinksTo from Nixops 1 module port";
    homepage = "https://github.com/nix-community/nixops-encrypted-links";
    license = licenses.mit;
    maintainers = [ ];
  };
}
