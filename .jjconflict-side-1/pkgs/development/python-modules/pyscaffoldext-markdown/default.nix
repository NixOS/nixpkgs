{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  wheel,
  importlib-metadata,
  myst-parser,
  pyscaffold,
  configupdater,
  pre-commit,
  pytest,
  pytest-cov-stub,
  pytest-xdist,
  tox,
  twine,
  virtualenv,
}:

buildPythonPackage rec {
  pname = "pyscaffoldext-markdown";
  version = "0.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fycTscq9rjUNFidWyeoH4QwedthdCdqqjXDO9DC4tds=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
    wheel
  ];

  propagatedBuildInputs = [
    importlib-metadata
    myst-parser
    pyscaffold
    wheel
  ];

  optional-dependencies = {
    testing = [
      configupdater
      pre-commit
      pytest
      pytest-cov-stub
      pytest-xdist
      setuptools-scm
      tox
      twine
      virtualenv
    ];
  };

  pythonImportsCheck = [ "pyscaffoldext.markdown" ];

  meta = with lib; {
    description = "PyScaffold extension which uses Markdown instead of reStructuredText";
    homepage = "https://pypi.org/project/pyscaffoldext-markdown/";
    license = licenses.mit;
    maintainers = with maintainers; [ matthewcroughan ];
  };
}
