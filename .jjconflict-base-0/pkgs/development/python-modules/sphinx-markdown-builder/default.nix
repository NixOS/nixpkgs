{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,

  # build system
  setuptools,
  wheel,

  # deps
  docutils,
  sphinx,
  tabulate,

  # tests
  pytestCheckHook,

  # optional deps
  black,
  bumpver,
  coveralls,
  flake8,
  isort,
  pip-tools,
  pylint,
  pytest,
  pytest-cov,
  sphinxcontrib-httpdomain,
  sphinxcontrib-plantuml,
}:

buildPythonPackage rec {
  pname = "sphinx-markdown-builder";
  version = "0.6.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "liran-funaro";
    repo = "sphinx-markdown-builder";
    tag = version;
    hash = "sha256-dPMOOG3myh9i2ez9uhasqLnlV0BEsE9CHEbZ57VWzAo=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    docutils
    sphinx
    tabulate
  ];

  optional-dependencies = {
    dev = [
      black
      bumpver
      coveralls
      flake8
      isort
      pip-tools
      pylint
      pytest
      pytest-cov
      sphinx
      sphinxcontrib-httpdomain
      sphinxcontrib-plantuml
    ];
  };

  pythonImportsCheck = [
    "sphinx_markdown_builder"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # NOTE: not sure why, but a `Missing dependencies: wheel` error happens when
  # `black` is included here, with python3.13
  checkInputs = lib.remove black optional-dependencies.dev;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Sphinx extension to add markdown generation support";
    homepage = "https://github.com/liran-funaro/sphinx-markdown-builder";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eljamm ];
  };
}
