{
  lib,
  fetchFromGitHub,
  python3,
}:

let
  python3' = python3.override {
    self = python3;
    packageOverrides = (
      final: prev: {
        cbor2 = prev.cbor2WithoutCExtensions;
      }
    );
  };
in

python3'.pkgs.buildPythonApplication rec {
  pname = "opshin";
  version = "0.24.3";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "OpShin";
    repo = "opshin";
    tag = version;
    hash = "sha256-2HfX4yNCVILGuztxwA1L+In+ZiSXLDaO+K9ccgHn3zw=";
  };

  propagatedBuildInputs = with python3'.pkgs; [
    setuptools
    poetry-core
    uplc
    pluthon
    pycardano
    frozenlist2
    astunparse
    ordered-set
  ];

<<<<<<< HEAD
  meta = {
    description = "Simple pythonic programming language for Smart Contracts on Cardano";
    homepage = "https://opshin.dev";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aciceri ];
=======
  meta = with lib; {
    description = "Simple pythonic programming language for Smart Contracts on Cardano";
    homepage = "https://opshin.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ aciceri ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "opshin";
  };
}
