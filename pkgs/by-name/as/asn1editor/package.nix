{
  lib,
  python3,
  fetchFromGitHub,
  wrapGAppsHook3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "asn1editor";
  version = "0.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Futsch1";
    repo = "asn1editor";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mgluhC2DMS4OyS/BoWqBdVf7GcxquOtOKTHZ/hbiHQM=";
  };

  build-system = with python3.pkgs; [
    setuptools
    wrapGAppsHook3
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

  meta = {
    description = "Python based editor for ASN.1 encoded data";
    homepage = "https://github.com/Futsch1/asn1editor";
    license = lib.licenses.mit;
    mainProgram = "asn1editor";
    maintainers = with lib.maintainers; [ bjornfor ];
  };
})
