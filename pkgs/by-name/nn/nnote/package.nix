{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "nnote";
  version = "0.1.3";
  __structuredAttrs = true;
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NDxZJpXQGOgkYXZyp3dTFja87tPXJ5j9b9rGvawTIRE=";
  };

  pyproject = true;

  build-system = with python3Packages; [
    setuptools
    wheel
  ];

  dependencies = with python3Packages; [
    click
    pyyaml
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  meta = {
    description = "A CLI note taker";
    homepage = "https://github.com/stiermid/nnote";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    mainProgram = "nnote";
  };
}
