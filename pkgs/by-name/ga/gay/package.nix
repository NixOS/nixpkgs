{
  lib,
  python3Packages,
  fetchPypi,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "gay";
  version = "1.3.4";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-pSxRrXnv4tfu7awVnOsQwC2ZOS4qsfCphFR/fpTNdPc=";
  };

  build-system = [ python3Packages.setuptools ];

  meta = {
    homepage = "https://github.com/ms-jpq/gay";
    description = "Colour your text / terminal to be more gay";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ CodeLongAndProsper90 ];
    mainProgram = "gay";
  };
})
