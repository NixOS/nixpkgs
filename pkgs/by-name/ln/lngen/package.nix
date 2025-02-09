{ lib
, haskellPackages
, fetchFromGitHub
}:

haskellPackages.mkDerivation {
  pname = "lngen";
  version = "unstable-2023-10-17";
  src = fetchFromGitHub {
    owner = "plclub";
    repo = "lngen";
    rev = "c7645001404e0e2fec2c56f128e30079b5b3fac6";
    hash = "sha256-2vUYHtl9yAadwdTtsjTI0klP+nRSYGXVpaSwD9EBTTI=";
  };
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = with haskellPackages; [ base syb parsec containers mtl ];
  executableHaskellDepends = with haskellPackages; [ base ];
  homepage = "https://github.com/plclub/lngen";
  description = "Tool for generating Locally Nameless definitions and proofs in Coq, working together with Ott";
  maintainers = with lib.maintainers; [ chen ];
  license = lib.licenses.mit;
}
