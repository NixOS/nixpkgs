{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  wheel,
  ta-lib,
  pandas,
}:

buildPythonPackage (finalAttrs: {
  pname = "technical";
  version = "1.6.0";
  src = fetchFromGitHub {
    owner = "freqtrade";
    repo = "technical";
    tag = finalAttrs.version;
    hash = "sha256-Xn5CfwgDhu+pPOkLGNLvfGwvGibw2Bp29zRFvtCbhC0=";
  };
  pyproject = true;
  build-system = [
    setuptools
    wheel
  ];
  dependencies = [
    ta-lib
    pandas
  ];
  meta = {
    description = "Various indicators developed or collected for the Freqtrade";
    homepage = "https://github.com/freqtrade/technical";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ n0099 ];
  };
})
