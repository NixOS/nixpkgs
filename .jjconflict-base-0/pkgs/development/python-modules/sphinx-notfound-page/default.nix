{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  pythonOlder,
  # documentation build dependencies
  sphinxHook,
  sphinx-prompt,
  sphinx-rtd-theme,
  sphinx-tabs,
  sphinx-autoapi,
  sphinxemoji,
  # runtime dependencies
  sphinx,
  setuptools,
}:

buildPythonPackage rec {
  pname = "sphinx-notfound-page";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  outputs = [
    "out"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "readthedocs";
    repo = "sphinx-notfound-page";
    rev = "refs/tags/${version}";
    hash = "sha256-tG71UuYbdlWNgq6Y5xRH3aWc9/eTr/RlsRNWSUjrbBE=";
  };

  nativeBuildInputs = [
    flit-core
    sphinxHook
    sphinx-prompt
    sphinx-rtd-theme
    sphinx-tabs
    sphinx-autoapi
    sphinxemoji
  ];

  buildInputs = [ sphinx ];

  propagatedBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "notfound" ];

  meta = with lib; {
    description = "Sphinx extension to create a custom 404 page with absolute URLs hardcoded";
    homepage = "https://github.com/readthedocs/sphinx-notfound-page";
    changelog = "https://github.com/readthedocs/sphinx-notfound-page/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ kaction ];
  };
}
