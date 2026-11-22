{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "cgt-calc";
  version = "4.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cgt-calc";
    repo = "capital-gains-calculator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VqrdPvBaQb+C6FNu+RggjtrF6zieB/DL/4rm+O2UjoU=";
  };

  patches = [
  ];

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    colorama
    defusedxml
    hatch-vcs
    iso4217parse
    jinja2
    openpyxl
    pandas
    pdfplumber
    pyrate-limiter
    requests
    setuptools-scm
    shtab
    types-requests
    typst
    xlrd
    yfinance
  ];

  pythonRelaxDeps = [
    "pandas"
    "shtab"
    "yfinance"
  ];

  meta = {
    description = "UK capital gains tax calculator";
    homepage = "https://github.com/cgt-calc/capital-gains-calculator";
    license = lib.licenses.mit;
    mainProgram = "cgt-calc";
    maintainers = with lib.maintainers; [ ambroisie ];
    platforms = lib.platforms.unix;
  };
})
