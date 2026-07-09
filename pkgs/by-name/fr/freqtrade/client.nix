{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  wheel,
  python-rapidjson,
  ccxt,
}:

buildPythonPackage (finalAttrs: {
  pname = "freqtrade-client";
  version = "2026.10";
  src = fetchFromGitHub {
    owner = "freqtrade";
    repo = "freqtrade";
    tag = finalAttrs.version;
    hash = "sha256-L/iZC4kKsQjgKw3X3uK7ZeMsjsS/Y9miJfj5dy1jfWA=";
    rootDir = "ft_client";
  };
  pyproject = true;
  build-system = [
    setuptools
    wheel
  ];
  dependencies = [
    ccxt.pinnedDeps.requests
    python-rapidjson
  ];
  meta = {
    description = "Provides a minimal rest client for the freqtrade rest api.";
    homepage = "https://github.com/freqtrade/freqtrade/tree/develop/ft_client";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ n0099 ];
  };
})
