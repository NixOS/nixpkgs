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
    owner = "fortran-lang";
    repo = "fprettify";
    rev = "v${finalAttrs.version}";
    hash = "sha256-0n9SiGl7xt0rgg5/trP4039FnThpMVfkqMPrSn0WZZ8=";
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
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
  };
})
