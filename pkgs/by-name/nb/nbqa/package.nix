{
  lib,
  python3Packages,
  fetchFromGitHub,

  # optional-dependencies
  ruff,

  # tests
  versionCheckHook,

  nix-update-script,
}:

let
  nbqa = python3Packages.buildPythonApplication rec {
    pname = "nbqa";
    version = "1.9.1";
    pyproject = true;

    src = fetchFromGitHub {
      owner = "nbQA-dev";
      repo = "nbQA";
      rev = "refs/tags/${version}";
      hash = "sha256-qVNJ8f8vUlTCi5DbvG70orcSnulH60UcI5iABtXYUog=";
    };

    build-system = with python3Packages; [
      setuptools
    ];

    optional-dependencies.toolchain =
      (with python3Packages; [
        black
        blacken-docs
        flake8
        isort
        jupytext
        mypy
        pylint
        pyupgrade
      ])
      ++ [
        ruff
      ];

    dependencies = with python3Packages; [
      autopep8
      ipython
      tokenize-rt
      tomli
    ];

    postPatch = ''
      # Force using the Ruff executable rather than the Python package
      substituteInPlace nbqa/__main__.py --replace 'if shell:' 'if shell or main_command == "ruff":'
    '';

    preCheck = ''
      # Allow the tests to run `nbqa` itself from the path
      export PATH="$out/bin":"$PATH"
    '';

    nativeCheckInputs =
      (with python3Packages; [
        autoflake
        distutils
        mdformat
        pre-commit-hooks
        pydocstyle
        pytestCheckHook
        yapf
      ])
      ++ lib.flatten (lib.attrValues optional-dependencies)
      ++ [ versionCheckHook ];
    versionCheckProgramArg = [ "--version" ];

    disabledTests = [
      # Test data not found
      "test_black_multiple_files"
      "test_black_return_code"
      "test_grep"
      "test_jupytext_on_folder"
      "test_mypy_works"
      "test_running_in_different_dir_works"
      "test_unable_to_reconstruct_message_pythonpath"
      "test_with_subcommand"
      "test_pylint_works"
    ];

    disabledTestPaths = [
      # Test data not found
      "tests/test_include_exclude.py"
    ];

    passthru = {
      # selector is a function mapping pythonPackages to a list of code quality
      # tools, e.g. nbqa.withTools (ps: [ ps.black ])
      withTools =
        selector:
        nbqa.overridePythonAttrs (
          { dependencies, ... }:
          {
            dependencies = dependencies ++ selector python3Packages;
            doCheck = false;
          }
        );

      updateScript = nix-update-script { };
    };

    meta = {
      homepage = "https://github.com/nbQA-dev/nbQA";
      changelog = "https://nbqa.readthedocs.io/en/latest/history.html";
      description = "Run ruff, isort, pyupgrade, mypy, pylint, flake8, black, blacken-docs, and more on Jupyter Notebooks";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ l0b0 ];
      mainProgram = "nbqa";
    };
  };
in
nbqa
