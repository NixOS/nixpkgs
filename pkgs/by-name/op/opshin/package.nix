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
  version = "0.24.2";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "OpShin";
    repo = "opshin";
    tag = version;
    hash = "sha256-L0vWEXlghXssT9oUw5AYG3/4ALoB/NH90JV8Kdl2n30=";
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

  meta = with lib; {
    description = "Simple pythonic programming language for Smart Contracts on Cardano";
    homepage = "https://opshin.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ t4ccer ];
    mainProgram = "opshin";
  };
}
