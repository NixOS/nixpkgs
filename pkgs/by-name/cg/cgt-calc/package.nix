{
  lib,
  fetchFromGitHub,
  python3Packages,
  withTeXLive ? true,
  texliveSmall,
}:
python3Packages.buildPythonApplication rec {
  pname = "cgt-calc";
  version = "1.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KapJI";
    repo = "capital-gains-calculator";
    rev = "v${version}";
    hash = "sha256-y/Y05wG89nccXyxfjqazyPJhd8dOkfwRJre+Rzx97Hw=";
  };

  build-system = with python3Packages; [
    poetry-core
  ];

  dependencies = with python3Packages; [
    defusedxml
    jinja2
    pandas
    requests
    types-requests
    yfinance
  ];

  makeWrapperArgs = lib.optionals withTeXLive [
    "--prefix"
    "PATH"
    ":"
    "${lib.getBin texliveSmall}/bin"
  ];

  meta = with lib; {
    description = "UK capital gains tax calculator";
    homepage = "https://github.com/KapJI/capital-gains-calculator";
    license = licenses.mit;
    mainProgram = "cgt-calc";
    maintainers = with maintainers; [ ambroisie ];
    platforms = platforms.unix;
  };
}
