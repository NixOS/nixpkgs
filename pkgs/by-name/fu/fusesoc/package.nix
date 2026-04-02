{
  python3Packages,
  fetchPypi,
  lib,
  iverilog,
  verilator,
  gnumake,
  gitMinimal,
  openssh,
  writableTmpDirAsHomeHook,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "fusesoc";
  version = "2.4.5";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-VBjJ7wiEz441iVquLMGabtdYbK07+dtHY05x8QzdSL8=";
  };

  build-system = with python3Packages; [
    setuptools
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    edalize
    pyparsing
    pyyaml
    simplesat
    fastjsonschema
    argcomplete
  ];

  nativeCheckInputs = [
    gitMinimal
    openssh
    python3Packages.pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "fusesoc" ];

  disabledTestPaths = [
    # These tests require network access
    "tests/test_coremanager.py::test_export"
    "tests/test_libraries.py::test_library_add"
    "tests/test_libraries.py::test_library_update_with_initialize"
    "tests/test_provider.py::test_git_provider"
    "tests/test_provider.py::test_github_provider"
    "tests/test_provider.py::test_url_provider"
    "tests/test_usecases.py::test_git_library_with_default_branch_is_added_and_updated"
    "tests/test_usecases.py::test_update_git_library_with_fixed_version"
  ];

  makeWrapperArgs = [
    "--suffix PATH : ${
      lib.makeBinPath [
        iverilog
        verilator
        gnumake
      ]
    }"
  ];

  meta = {
    homepage = "https://github.com/olofk/fusesoc";
    description = "Package manager and build tools for HDL code";
    maintainers = [ ];
    license = lib.licenses.bsd3;
    mainProgram = "fusesoc";
  };
})
