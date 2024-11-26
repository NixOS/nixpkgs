{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  sphinx,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "sphinx-multiversion";
  version = "0.2.4";

  disabled = pythonOlder "3.7";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "sphinx-multiversion";
    hash = "sha256-XNHKnste7WPLjWzl6cQ4yhOvT6mOfrbzdr5UHdSZC8s=";
  };

  build-system = [ setuptools ];
  dependencies = [ sphinx ];

  pythonImportsCheck = [ "sphinx_multiversion" ];

  meta = with lib; {
    description = "Sphinx extension for building self-hosted versioned docs.";
    homepage = "https://sphinx-contrib.github.io/multiversion";
    changelog = "https://github.com/sphinx-contrib/multiversion/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ cynerd ];
  };
}
