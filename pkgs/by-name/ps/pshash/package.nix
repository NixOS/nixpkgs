{
  haskellPackages,
  fetchFromGitHub,
  lib,
}:
haskellPackages.mkDerivation rec {
  pname = "pshash";
  version = "0.1.11.0";
  src = fetchFromGitHub {
    owner = "thornoar";
    repo = "pshash";
    rev = "v${version}";
    hash = "sha256-2lb8WxZb9e3hTnBiXAbyOer9EqbBEsnOAbJfPPdvIGc=";
  };

  isLibrary = false;
  isExecutable = true;
  doCheck = false;

  executableHaskellDepends = with haskellPackages; [
    base
    containers
    directory
  ];

  license = lib.licenses.mit;
  description = "Functional pseudo-hash password creation tool";
  homepage = "https://github.com/thornoar/pshash";
  maintainers = with lib.maintainers; [ thornoar ];
  mainProgram = "pshash";
}
