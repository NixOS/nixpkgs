{
  lib,
  buildPythonPackage,
  coincidence,
  domdf-python-tools,
  fetchFromGitHub,
  pytest-datadir,
  pytest-regressions,
  pytestCheckHook,
  tinycss2,
  whey,
}:

buildPythonPackage (finalAttrs: {
  pname = "dict2css";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sphinx-toolbox";
    repo = "dict2css";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6xVK4NBrg7v7iqbVwPcUGLYpm9Me3GCik1hRzjS0i7A=";
  };

  build-system = [ whey ];

  dependencies = [
    domdf-python-tools
    tinycss2
  ];

  nativeCheckInputs = [
    coincidence
    pytest-datadir
    pytest-regressions
    pytestCheckHook
  ];

  pythonImportsCheck = [ "dict2css" ];

  meta = {
    description = "μ-library for constructing cascading style sheets from Python dictionaries";
    homepage = "https://github.com/sphinx-toolbox/dict2css";
    changelog = "https://github.com/sphinx-toolbox/dict2css/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
