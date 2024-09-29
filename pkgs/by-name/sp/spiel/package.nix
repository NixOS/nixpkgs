{
  lib,
  stdenv,
  python312Packages,
  callPackage,
  fetchPypi,
}:

python312Packages.buildPythonApplication rec {
  pname = "spiel";
  version = "0.5.1";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-5Xrc2X14RP0ik4IwB9RA1Uhp2OTjHn2/LT+LN3ZCNoc=";
  };

  propagatedBuildInputs = with python312Packages; [
    poetry-core
    more-itertools
    rich
    typer
    watchfiles
    pillow
    textual
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [ "textual" ];

  meta = with lib; {
    description = "Spiel is a framework for building and presenting richly-styled presentations in your terminal using Python.";
    license = licenses.mit;
    maintainers = with maintainers; [ mariunaise ];
  };
}
