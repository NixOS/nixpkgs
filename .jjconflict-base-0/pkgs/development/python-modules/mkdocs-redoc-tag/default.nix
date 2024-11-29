{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  mkdocs,
  mkdocs-material,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "mkdocs-redoc-tag";
  version = "0.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Blueswen";
    repo = "mkdocs-redoc-tag";
    rev = "refs/tags/v${version}";
    hash = "sha256-TOGFch+Uto3qeVMaHqK8SEy0v0cKtHofoGE8T1mnBOk=";
  };

  propagatedBuildInputs = [
    mkdocs
    beautifulsoup4
  ];

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    mkdocs-material
    pytestCheckHook
  ];

  meta = with lib; {
    description = "MkDocs plugin supports for add Redoc UI in page";
    homepage = "https://github.com/blueswen/mkdocs-redoc-tag";
    changelog = "https://github.com/blueswen/mkdocs-redoc-tag/blob/v${version}/CHANGELOG";
    license = licenses.mit;
    maintainers = with maintainers; [ benhiemer ];
  };
}
