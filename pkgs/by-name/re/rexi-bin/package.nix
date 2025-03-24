{
  fetchPypi,
  python3Packages,
  lib,
}:
let
in
python3Packages.buildPythonPackage rec {
  pname = "rexi-bin";
  version = "1.2.0";
  format = "wheel";

  propagatedBuildInputs = with python3Packages; [
    typer
    textual
    colorama
  ];

  src = fetchPypi rec {
    inherit version format;
    pname = "rexi";
    python = "py3";
    dist = python;
    sha256 = "sha256-W2f5/qwQ3jbofxqoNgBN57zrH9d9CRt2KJcF0PWjLX4=";
  };

  meta = with lib; {
    description = "User-friendly terminal UI to interactively work with regular expressions.";
    homepage = "https://github.com/royreznik/rexi";
    license = licenses.mit;
    maintainers = [ ];
    mainProgram = "rexi";
  };
}
