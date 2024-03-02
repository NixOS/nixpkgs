{ lib
, buildPythonPackage
, fetchFromGitHub
, unstableGitUpdater
, poetry-core
, hetzner
, nixops
, nixos-modules-contrib
, typing-extensions
}:

buildPythonPackage {
  pname = "nixops-hetzner";
  version = "unstable-2022-04-23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "nixops-hetzner";
    rev = "bc7a68070c7371468bcc8bf6e36baebc6bd2da35";
    hash = "sha256-duK1Ui4VpbGSgGvfjTOddHSqHZ1FSy4L9Egg+FvZv04=";
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
    hetzner
    nixos-modules-contrib
    typing-extensions
  ];

  pythonImportsCheck = [ "nixops_hetzner" ];

  passthru.updateScript = unstableGitUpdater {};

  meta = with lib; {
    description = "Hetzner bare metal NixOps plugin";
    homepage = "https://github.com/NixOS/nixops-hetzner";
    license = licenses.mit;
    maintainers = nixops.meta.maintainers;
  };
}
