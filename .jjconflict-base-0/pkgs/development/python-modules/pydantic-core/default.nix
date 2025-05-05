{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cargo,
  rustPlatform,
  rustc,
  libiconv,
  typing-extensions,
  pytestCheckHook,
  hypothesis,
  pytest-timeout,
  pytest-mock,
  dirty-equals,
  pydantic,
}:

let
  pydantic-core = buildPythonPackage rec {
    pname = "pydantic-core";
    version = "2.33.0";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "pydantic";
      repo = "pydantic-core";
      tag = "v${version}";
      hash = "sha256-F+ie8cJ1xl8i3kQSH6H24Vi5KSkRGjX/bXIfzY+ZayM=";
    };

    cargoDeps = rustPlatform.fetchCargoVendor {
      inherit src;
      name = "${pname}-${version}";
      hash = "sha256-bGhS36Fc7LUdpTHsIM1zn1vX2T/OX+fPewLxLGSZRrk=";
    };

    nativeBuildInputs = [
      cargo
      rustPlatform.cargoSetupHook
      rustc
    ];

    build-system = [
      rustPlatform.maturinBuildHook
      typing-extensions
    ];

    buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

    dependencies = [ typing-extensions ];

    pythonImportsCheck = [ "pydantic_core" ];

    # escape infinite recursion with pydantic via dirty-equals
    doCheck = false;
    passthru.tests.pytest = pydantic-core.overrideAttrs { doCheck = true; };

    nativeCheckInputs = [
      pytestCheckHook
      hypothesis
      pytest-timeout
      dirty-equals
      pytest-mock
    ];

    disabledTests = [
      # RecursionError: maximum recursion depth exceeded while calling a Python object
      "test_recursive"
    ];

    disabledTestPaths = [
      # no point in benchmarking in nixpkgs build farm
      "tests/benchmarks"
    ];

    meta = with lib; {
      changelog = "https://github.com/pydantic/pydantic-core/releases/tag/v${version}";
      description = "Core validation logic for pydantic written in rust";
      homepage = "https://github.com/pydantic/pydantic-core";
      license = licenses.mit;
      maintainers = pydantic.meta.maintainers;
    };
  };
in
pydantic-core
