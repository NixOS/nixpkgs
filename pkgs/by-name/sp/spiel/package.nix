{
  lib,
  python3Packages,
  fetchPypi,
}:

let
  # Override textual version to 0.11.1 because slide transitions are broken otherwise
  textualOverride = python3Packages.buildPythonPackage rec {
    pname = "textual";
    version = "0.11.1";

    src = fetchPypi {
      pname = "textual";
      inherit version;
      sha256 = "sha256-mwJ4U7aGrJVho9xvK2N6JQifLuZ6nje7850Np1Z2lLA=";
    };
  };
in
python3Packages.buildPythonApplication rec {
  pname = "spiel";
  version = "0.5.1";

  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5Xrc2X14RP0ik4IwB9RA1Uhp2OTjHn2/LT+LN3ZCNoc=";
  };

  dependencies = with python3Packages; [
    poetry-core
    more-itertools
    rich
    typer
    watchfiles
    pillow
    textualOverride
  ];

  meta = with lib; {
    description = "Framework for building and presenting richly-styled presentations in a terminal using Python.";
    license = licenses.mit;
    maintainers = with maintainers; [ mariunaise ];
  };
}
