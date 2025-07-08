{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "fprettify";
  version = "0.3.7";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pseewald";
    repo = "fprettify";
    rev = "v${version}";
    sha256 = "17v52rylmsy3m3j5fcb972flazykz2rvczqfh8mxvikvd6454zyj";
  };

  preConfigure = ''
    patchShebangs fprettify.py
  '';

  propagatedBuildInputs = with python3Packages; [
    configargparse
  ];

  meta = with lib; {
    description = "Auto-formatter for modern Fortran code that imposes strict whitespace formatting, written in Python";
    mainProgram = "fprettify";
    homepage = "https://pypi.org/project/fprettify/";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fabiangd ];
  };
}
