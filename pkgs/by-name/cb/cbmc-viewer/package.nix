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

  meta = with lib; {
    description = "Produces browsable summary of CBMC model checker output";
    homepage = "https://github.com/model-checking/cbmc-viewer";
    license = licenses.asl20;
    maintainers = with maintainers; [ jacg ];
    mainProgram = "cbmc-viewer";
  };
}
