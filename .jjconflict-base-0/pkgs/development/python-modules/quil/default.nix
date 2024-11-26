{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  rustPlatform,
  numpy,
  pytestCheckHook,
  syrupy,
  libiconv,
}:

buildPythonPackage rec {
  pname = "quil";
  version = "0.13.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "rigetti";
    repo = "quil-rs";
    rev = "quil-py/v${version}";
    hash = "sha256-Hapj90F5IloyW7MyeTg95rlUfb4JiZdtz1HuJVxlk/c=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-yfO1/ChiFYTB/LWCc9CR3lBzU71FEos+jjkHVoJyoeI=";
  };

  buildAndTestSubdir = "quil-py";

  build-system = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

  dependencies = [ numpy ];

  pythonImportsCheck = [
    "quil.expression"
    "quil.instructions"
    "quil.program"
    "quil.validation"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    syrupy
  ];

  disabledTests = [
    # Syrupy snapshot needs to be regenerated
    "test_filter_instructions"
  ];

  meta = {
    changelog = "https://github.com/rigetti/quil-rs/blob/${src.rev}/quil-py/CHANGELOG.md";
    description = "Python package for building and parsing Quil programs";
    homepage = "https://github.com/rigetti/quil-rs/tree/main/quil-py";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
