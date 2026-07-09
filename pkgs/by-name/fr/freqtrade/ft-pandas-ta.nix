{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  fetchPypi,
  wheel,
  numpy,
  pandas,
}:

buildPythonPackage (finalAttrs: {
  pname = "ft-pandas-ta";
  version = "0.3.16";
  src = fetchFromGitHub {
    owner = "freqtrade";
    repo = "pandas-ta";
    tag = finalAttrs.version;
    hash = "sha256-xT8/42BU27ZEGjQsfXF/5N2N+NrAJZrAQ2MM1hcetvc=";
  };
  pyproject = true;
  build-system = [
    (setuptools.overridePythonAttrs rec {
      # https://github.com/freqtrade/pandas-ta/commit/cf1b52b2de85525c299654d8f1e6dd607f4acaa1
      # https://github.com/freqtrade/pandas-ta/commit/9d7218ed6a120804bd56e3e0381a58a9c2b52720
      version = "75.6.0";
      src = fetchPypi {
        pname = "setuptools";
        inherit version;
        hash = "sha256-gZkiJVjffIYhavT4TDDps0ph2LoZNmzJFEJM29KCUvY=";
      };
    })
    wheel
  ];
  dependencies = [
    numpy
    pandas
  ];
  meta = {
    description = "An easy to use Python 3 Pandas Extension with 130+ Technical Analysis Indicators.";
    homepage = "https://github.com/freqtrade/pandas-ta";
    changelog = "https://github.com/freqtrade/pandas-ta/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ n0099 ];
  };
})
