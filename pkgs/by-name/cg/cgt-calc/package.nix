{
  lib,
  fetchFromGitHub,
  fetchpatch,
  python3Packages,
  withTeXLive ? true,
  texliveSmall,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "cgt-calc";
  version = "1.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KapJI";
    repo = "capital-gains-calculator";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6iOlDNlpfCrbRCxEJsRYw6zqOehv/buVN+iU6J6CtIk=";
  };

  patches = [
    # https://github.com/KapJI/capital-gains-calculator/pull/715
    (fetchpatch {
      url = "https://github.com/KapJI/capital-gains-calculator/commit/ec7155c1256b876d5906a3885656489e9fdd798c.patch";
      hash = "sha256-pfGHSKuDRF0T1hP7kpRC285limd1voqLXcXCP7mAD3s=";
    })
  ];

  pythonRelaxDeps = [
    "defusedxml"
  ];

  build-system = with python3Packages; [
    poetry-core
  ];

  dependencies = with python3Packages; [
    defusedxml
    jinja2
    pandas
    requests
    pyrate-limiter
    types-requests
    yfinance
  ];

  makeWrapperArgs = lib.optionals withTeXLive [
    "--prefix"
    "PATH"
    ":"
    "${lib.getBin texliveSmall}/bin"
  ];

  meta = {
    description = "UK capital gains tax calculator";
    homepage = "https://github.com/KapJI/capital-gains-calculator";
    license = lib.licenses.mit;
    mainProgram = "cgt-calc";
    maintainers = with lib.maintainers; [ ambroisie ];
    platforms = lib.platforms.unix;
  };
})
