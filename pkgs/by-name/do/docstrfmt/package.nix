{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "docstrfmt";
  version = "2.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LilSpazJoekp";
    repo = "docstrfmt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N2uPFOdDvAUL9eV4kn8MYM6OTMWJm24inlyY+k9Eqm8=";
  };

  build-system = [
    python3Packages.flit-core
  ];

  pythonRelaxDeps = [
    # https://github.com/LilSpazJoekp/docstrfmt/issues/186
    "types-docutils"
  ];

  dependencies = with python3Packages; [
    black
    click
    coverage
    docutils
    docutils-stubs
    libcst
    platformdirs
    roman
    sphinx
    tabulate
    tomli
    types-docutils
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-aiohttp
  ];

  pythonImportsCheck = [
    "docstrfmt"
  ];

  meta = {
    description = "Formatter for reStructuredText";
    homepage = "https://github.com/LilSpazJoekp/docstrfmt";
    changelog = "https://github.com/LilSpazJoekp/docstrfmt/blob/${finalAttrs.src.tag}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
    mainProgram = "docstrfmt";
  };
})
