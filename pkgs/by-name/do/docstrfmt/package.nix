{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "docstrfmt";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LilSpazJoekp";
    repo = "docstrfmt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DMeTrFHSJpUPBsE70dZ96WwQuY6C1POAGOJkSRfa2ho=";
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

  disabledTests = [
    # Failure due to different behavior of click, see:
    # https://github.com/LilSpazJoekp/docstrfmt/issues/232
    "test_invalid_line_length[tests/test_files/test_file.rst]"
    "test_invalid_line_length[tests/test_files/py_file.py]"
    "test_invalid_pyproject_toml"
    "test_cache_single_file"
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
