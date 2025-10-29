{
  stdenv,
  lib,
  python3Packages,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
  gitMinimal,
}:

python3Packages.buildPythonPackage rec {
  pname = "gcovr";
  version = "8.4";
  pyproject = true;

  disabled = python3Packages.pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "gcovr";
    repo = "gcovr";
    tag = version;
    hash = "sha256-v3jNODYD9qa3mwttfuldhhIHrfR5LcsZ+WNWiOWb35E=";
  };

  build-system = with python3Packages; [
    hatchling
    hatch-fancy-pypi-readme
    hatch-vcs
  ];

  # pythonRelaxDeps do not work on pyproject.toml
  preBuild = ''
    substituteInPlace pyproject.toml \
      --replace-fail "hatchling==1.26.3" "hatchling"
    substituteInPlace pyproject.toml \
      --replace-fail "hatch-fancy-pypi-readme==24.1.0" "hatch-fancy-pypi-readme>=24.1.0"
    substituteInPlace pyproject.toml \
      --replace-fail "hatch-vcs==0.4.0" "hatch-vcs>=0.4.0"
  '';

  dependencies =
    with python3Packages;
    (
      [
        colorlog
        jinja2
        lxml
        pygments
      ]
      ++ lib.optionals (pythonOlder "3.11") [ tomli ]
    );

  pythonImportsCheck = [
    "gcovr"
    "gcovr.configuration"
  ];

  preCheck = ''
    rm -rf src # this causes some pycache issues
    rm -rf admin/bump_version.py
    export CC_REFERENCE="gcc-${lib.versions.major stdenv.cc.version}"
  '';

  nativeCheckInputs = with python3Packages; [
    writableTmpDirAsHomeHook
    pytestCheckHook
    pytest-timeout
    yaxmldiff
    nox
    requests
    gitMinimal
  ];

  disabledTests = [
    # too fragile
    "test_build"
    "test_example"
    # assert 40 == 30 on log levels
    "test_multiple_output_formats_to_stdout"
    "test_multiple_output_formats_to_stdout_1"
  ];

  meta = {
    description = "Python script for summarizing gcov data";
    homepage = "https://www.gcovr.com/";
    changelog = "https://github.com/gcovr/gcovr/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.bsd0;
    maintainers = with lib.maintainers; [ sigmanificient ];
    mainProgram = "gcovr";
  };
}
