{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "csvs-to-sqlite";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "csvs-to-sqlite";
    rev = finalAttrs.version;
    hash = "sha256-hjimoIoHJdDyKzoJfWdRONUh7yLsR/d8n8zYbb6BKhk=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    click
    dateparser
    pandas
    py-lru-cache
    six
  ];

  pythonRelaxDeps = [
    "click"
  ];

  nativeCheckInputs = with python3.pkgs; [
    cogapp
    pytestCheckHook
  ];

  disabledTests = [
    # Test needs to be adjusted for click >= 8.
    "test_if_cog_needs_to_be_run"
  ];

  meta = {
    description = "Convert CSV files into a SQLite database";
    homepage = "https://github.com/simonw/csvs-to-sqlite";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.costrouc ];
    mainProgram = "csvs-to-sqlite";
  };
})
