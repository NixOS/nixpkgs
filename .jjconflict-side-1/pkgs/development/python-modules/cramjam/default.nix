{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pyprojectVersionPatchHook,
  rustPlatform,

  # tests
  hypothesis,
  numpy,
  pytest-xdist,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "cramjam";
  version = "2.13.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "milesgranger";
    repo = "cramjam";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sdmIcRSy2nJcqV9NGzBYt0J6R9Qs7zkVfXFG9CqoMs4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname src version;
    hash = "sha256-L+OsrsAlA0B42wgAPAPFHI8ebGx6SYZlEkMLWQQFGxA=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.maturinBuildHook
    pyprojectVersionPatchHook
  ];

  nativeCheckInputs = [
    hypothesis
    numpy
    pytest-xdist
    pytestCheckHook
  ];

  env = {
    # Makes tests less flaky by relaxing performance constraints
    # https://github.com/HypothesisWorks/hypothesis/issues/3713
    CI = true;
  };

  disabledTests = [
    # I (@GaetanLepage) cannot reproduce the failure, but it fails consistently on Ofborg with:
    # SyntaxError: could not convert string to float: 'V' - Consider hexadecimal for huge integer literals to avoid decimal conversion limits.
    "test_variants_decompress_into"
  ];

  disabledTestPaths = [
    "benchmarks/test_bench.py"
  ];

  pythonImportsCheck = [ "cramjam" ];

  meta = {
    description = "Thin Python bindings to de/compression algorithms in Rust";
    homepage = "https://github.com/milesgranger/pyrus-cramjam";
    changelog = "https://github.com/milesgranger/cramjam/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
