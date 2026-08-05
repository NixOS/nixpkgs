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
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KapJI";
    repo = "capital-gains-calculator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KPzADW+n82X08IMfSIl5JyYPm8fxbbowud8sBdUxRgA=";
  };

  patches = [
    (fetchpatch {
      # https://github.com/KapJI/capital-gains-calculator/pull/781
      name = "update uv-build requirement.patch";
      url = "https://github.com/KapJI/capital-gains-calculator/commit/0222eafdcf1911f3e2fd781697dc53311f529f62.patch";
      hash = "sha256-L8jgrdA9t3x8mdaLmAuW6vFhHCLGA+0gQ/8j9EcYKhE=";
    })
  ];

  build-system = with python3Packages; [
    uv-build
  ];

  dependencies = with python3Packages; [
    defusedxml
    jinja2
    pandas
    requests
    pyrate-limiter
    types-requests
    yfinance
    colorama
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
