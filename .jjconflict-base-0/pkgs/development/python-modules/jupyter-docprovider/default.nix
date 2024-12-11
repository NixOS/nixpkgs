{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  hatch-jupyter-builder,
  jupyter-collaboration,
}:

buildPythonPackage rec {
  pname = "jupyter-docprovider";
  version = "1.0.1";
  pyproject = true;

  src = fetchPypi {
    pname = "jupyter_docprovider";
    inherit version;
    hash = "sha256-0MG81KLpeBrNFD8osbhGhZIVc7NHlp9UI4j8QIwfjc4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ', "jupyterlab>=4.0.0"' ""
  '';

  build-system = [
    hatchling
    hatch-jupyter-builder
  ];

  pythonImportsCheck = [ "jupyter_docprovider" ];

  # no tests
  doCheck = false;

  passthru.tests = jupyter-collaboration.tests;

  meta = {
    description = "JupyterLab/Jupyter Notebook 7+ extension integrating collaborative shared models";
    homepage = "https://github.com/jupyterlab/jupyter-collaboration/tree/main/projects/jupyter-docprovider";
    license = lib.licenses.bsd3;
    maintainers = lib.teams.jupyter.members;
  };
}
