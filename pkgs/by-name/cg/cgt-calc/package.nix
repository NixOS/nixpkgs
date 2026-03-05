{
  lib,
  fetchFromGitHub,
  python3Packages,
  withTeXLive ? true,
  texliveSmall,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "cgt-calc";
  # Includes updates to use pyrate-limiter v4 that are not released yet
  # unfortunately.
  version = "1.14.0-unstable-2026-02-23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "KapJI";
    repo = "capital-gains-calculator";
    rev = "3326514c8e99904eeeda676948c4404da6fe1adc";
    hash = "sha256-6iOlDNlpfCrbRCxEJsRYw6zqOehv/buVN+iU6J6CtIk=";
  };

  pythonRelaxDeps = [
    # The built wheel holds an upper bound requirement for the version of these
    # dependenceis, while pyproject.toml doesn't. Upstream's `uv.lock` even
    # uses yfinance 1.2.0 . See:
    # https://github.com/KapJI/capital-gains-calculator/pull/744
    "defusedxml"
    "yfinance"
  ];
  pythonRemoveDeps = [
    # Upstream's uv.lock doesn't reference this dependency, and lists
    # pyrate-limiter instead. The built wheel from some reason requests it
    # never the less.
    "requests-ratelimiter"
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
