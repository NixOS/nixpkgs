{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "fprettify";
  version = "0.3.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pseewald";
    repo = "fprettify";
    rev = "v${finalAttrs.version}";
    sha256 = "17v52rylmsy3m3j5fcb972flazykz2rvczqfh8mxvikvd6454zyj";
  };

  preConfigure = ''
    patchShebangs fprettify.py
  '';

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    configargparse
  ];

  meta = {
    description = "Auto-formatter for modern Fortran code that imposes strict whitespace formatting, written in Python";
    mainProgram = "fprettify";
    homepage = "https://pypi.org/project/fprettify/";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ fabiangd ];
  };
})
