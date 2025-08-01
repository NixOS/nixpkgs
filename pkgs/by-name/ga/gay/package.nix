{
  lib,
  python3Packages,
  fetchPypi,
}:
python3Packages.buildPythonApplication rec {
  pname = "gay";
  version = "1.3.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pSxRrXnv4tfu7awVnOsQwC2ZOS4qsfCphFR/fpTNdPc=";
  };

  build-system = [ python3Packages.setuptools ];

  meta = with lib; {
    homepage = "https://github.com/ms-jpq/gay";
    description = "Colour your text / terminal to be more gay";
    license = licenses.mit;
    maintainers = with maintainers; [ CodeLongAndProsper90 ];
    mainProgram = "gay";
  };
}
