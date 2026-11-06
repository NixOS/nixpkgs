{
  lib,
  fetchFromGitHub,
  python3Packages,
  withTeXLive ? true,
  texliveSmall,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "cgt-calc";
  version = "3.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cgt-calc";
    repo = "capital-gains-calculator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ApmMnNL5l5W4IA8lWqtcDJM78Zt2vvdXfKaaDZzC8GM=";
  };

  patches = [
  ];

  build-system = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    colorama
    defusedxml
    iso4217parse
    jinja2
    openpyxl
    pandas
    pdfplumber
    pyrate-limiter
    requests
    shtab
    types-requests
    xlrd
    yfinance
  ];

  pythonRelaxDeps = [
    "pandas"
    "shtab"
    "yfinance"
  ];

  makeWrapperArgs = lib.optionals withTeXLive [
    "--prefix"
    "PATH"
    ":"
    "${lib.getBin texliveSmall}/bin"
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
