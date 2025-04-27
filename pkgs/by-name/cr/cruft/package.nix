{
  python3Packages,
  fetchFromGitHub,
  lib,
}:
python3Packages.buildPythonApplication rec {
  pname = "cruft";
  version = "2.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cruft";
    repo = "cruft";
    tag = version;
    hash = "sha256-hUucSfgDBlT5jVk/oF8JjbcYhjHgkprfGRwsSNfgjfg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'
  '';

  build-system = with python3Packages; [
    hatchling
  ];

  nativeCheckInputs = with python3Packages; [
    pytest7CheckHook
  ];

  dependencies =
    with python3Packages;
    [
      click
      cookiecutter
      gitpython
      typer
    ]
    ++ lib.optional (pythonOlder "3.11") python3Packages.toml;

  pythonImportsCheck = "cruft";

  # Unfortunately, some tests require internet access to fully clone
  # https://github.com/cruft/cookiecutter-test (including all branches)
  # which is possible to package, but is annoying and may be not always pure
  #
  # See https://discourse.nixos.org/t/keep-git-folder-in-when-fetching-a-git-repo/8590/6
  #
  # There are only 13 tests which do not require internet access on moment of the writing.
  # But some tests are better than none, right?
  disabledTests = [
    "test_get_diff_with_add"
    "test_get_diff_with_delete"
    "test_get_diff_with_unicode"
  ];

  disabledTestPaths = [
    "tests/test_api.py" # only 2 tests pass, and 24 fail. I am going to ignore entire file
    "tests/test_cli.py"
  ];

  meta = {
    changelog = "https://github.com/cruft/cruft/blob/${version}/CHANGELOG.md";
    description = "Allows you to maintain all the necessary boilerplate for building projects";
    homepage = "https://github.com/cruft/cruft";
    license = lib.licenses.mit;
    mainProgram = "cruft";
    maintainers = with lib.maintainers; [ perchun ];
  };
}
