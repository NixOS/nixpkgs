{
  lib,
  fetchFromGitHub,
  python3Packages,
  addBinToPathHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "parquet-tools";
  version = "0.2.16";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "ktrueda";
    repo = "parquet-tools";
    tag = finalAttrs.version;
    hash = "sha256-mV66R5ejfzH1IasmoyAWAH5vzrnLVVhOqKBMfWKIVY0=";
  };

  patches = [
    # support Moto 5.x
    # https://github.com/ktrueda/parquet-tools/pull/55
    ./moto5.patch
  ];

  pythonRelaxDeps = [
    "pandas"
    "tabulate"
    "thrift"
  ];

  build-system = with python3Packages; [
    poetry-core
  ];

  dependencies = with python3Packages; [
    boto3
    colorama
    halo
    pandas
    pyarrow
    tabulate
    thrift
  ];

  nativeCheckInputs =
    with python3Packages;
    [
      moto
      pytest-mock
      pytestCheckHook
    ]
    ++ [
      addBinToPathHook
    ];

  disabledTests = [
    # test file is 2 bytes bigger than expected
    "test_excute_simple"
  ];

  pythonImportsCheck = [
    "parquet_tools"
  ];

  meta = {
    description = "CLI tool for parquet files";
    homepage = "https://github.com/ktrueda/parquet-tools";
    changelog = "https://github.com/ktrueda/parquet-tools/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cpcloud ];
    mainProgram = "parquet-tools";
  };
})
