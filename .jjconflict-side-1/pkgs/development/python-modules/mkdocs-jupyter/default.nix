{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  ipykernel,
  jupytext,
  mkdocs,
  mkdocs-material,
  nbconvert,
  pygments,
  pytestCheckHook,
  pytest-cov-stub,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "mkdocs-jupyter";
  version = "0.26.1";
  pyproject = true;

  src = fetchPypi {
    pname = "mkdocs_jupyter";
    inherit version;
    hash = "sha256-fIDA05U96R5bQKDTIJIzeVyPgAJDqymOTsOOBQTtpjA=";
  };

  pythonRelaxDeps = [
    "ipykernel"
    "nbconvert"
  ];

  build-system = [ hatchling ];

  nativeBuildInputs = [
    writableTmpDirAsHomeHook
  ];

  dependencies = [
    ipykernel
    jupytext
    mkdocs
    mkdocs-material
    nbconvert
    pygments
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "mkdocs_jupyter" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Use Jupyter Notebook in mkdocs";
    homepage = "https://github.com/danielfrg/mkdocs-jupyter";
    changelog = "https://github.com/danielfrg/mkdocs-jupyter/blob/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ net-mist ];
  };
}
