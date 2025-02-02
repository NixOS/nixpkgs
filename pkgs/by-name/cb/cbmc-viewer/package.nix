{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication rec {
  pname = "cbmc-viewer";
  version = "3.8";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JFL06z7lJWZxTALovDBVwNJWenWPUQV9J0qZz3Ek6gI=";
  };

  propagatedBuildInputs = with python3Packages; [
    setuptools
    jinja2
    voluptuous
  ];

  meta = {
    description = "Produces browsable summary of CBMC model checker output";
    homepage = "https://github.com/model-checking/cbmc-viewer";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jacg ];
    mainProgram = "cbmc-viewer";
  };
}
