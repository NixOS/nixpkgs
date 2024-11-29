{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  loguru,
  poetry-core,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "mobi";
  version = "0.3.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "iscc";
    repo = "mobi";
    rev = "refs/tags/v${version}";
    hash = "sha256-g1L72MkJdrKQRsEdew+Qsn8LfCn8+cmj2pmY6s4nv2U=";
  };

  pythonRelaxDeps = [ "loguru" ];

  nativeBuildInputs = [
    poetry-core
    setuptools
  ];

  propagatedBuildInputs = [ loguru ];

  pythonImportsCheck = [ "mobi" ];

  meta = with lib; {
    description = "Library for unpacking unencrypted mobi files";
    mainProgram = "mobiunpack";
    homepage = "https://github.com/iscc/mobi";
    license = licenses.gpl3Only;
    maintainers = [ ];
  };
}
