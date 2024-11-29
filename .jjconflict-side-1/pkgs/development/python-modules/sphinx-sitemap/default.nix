{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  sphinx,
  sphinx-pytest,
  defusedxml,
  pytestCheckHook,
}:
let
  pname = "sphinx-sitemap";
  version = "2.6.0";
in
buildPythonPackage {
  inherit pname version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jdillard";
    repo = "sphinx-sitemap";
    rev = "refs/tags/v${version}";
    hash = "sha256-RERa+/MVug2OQ/FAXS4LOQHB4eEuIW2rwcdZUOrr6g8=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ sphinx ];

  nativeCheckInputs = [
    pytestCheckHook
    sphinx-pytest
    defusedxml
  ];

  meta = with lib; {
    changelog = "https://github.com/jdillard/sphinx-sitemap/releases/tag/v${version}";
    description = "Sitemap generator for Sphinx";
    homepage = "https://github.com/jdillard/sphinx-sitemap";
    maintainers = with maintainers; [ alejandrosame ];
    license = licenses.mit;
  };
}
