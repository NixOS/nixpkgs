{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "asn1editor";
  version = "0.8.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Futsch1";
    repo = "asn1editor";
    rev = "v${version}";
    hash = "sha256-mgluhC2DMS4OyS/BoWqBdVf7GcxquOtOKTHZ/hbiHQM=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    asn1tools
    coverage
    wxpython
  ];

  pythonImportsCheck = [ "asn1editor" ];

  # Tests fail in sandbox, e.g.
  # "SystemExit: Unable to access the X Display, is $DISPLAY set properly?"
  doCheck = false;

  meta = with lib; {
    description = "Python based editor for ASN.1 encoded data";
    homepage = "https://github.com/Futsch1/asn1editor";
    license = licenses.mit;
    mainProgram = "asn1editor";
    maintainers = with maintainers; [ bjornfor ];
  };
}
