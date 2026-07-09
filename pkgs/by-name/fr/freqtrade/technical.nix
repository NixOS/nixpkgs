{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  ta-lib,
  pandas,
}:

buildPythonPackage (finalAttrs: {
  pname = "technical";
  version = "1.7.0";
  src = fetchFromGitHub {
    owner = "freqtrade";
    repo = "technical";
    tag = finalAttrs.version;
    hash = "sha256-Ltab9QTiyH3lSCbHTi+MO2F6joMb1CJjQ6hCznCmP1w=";
  };
  pyproject = true;
  build-system = [ setuptools ];
  dependencies = [
    ta-lib
    pandas
  ];
  meta = {
    description = "Various indicators developed or collected for the Freqtrade";
    homepage = "https://github.com/freqtrade/technical";
    changelog = "https://github.com/freqtrade/technical/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ n0099 ];
  };
})
