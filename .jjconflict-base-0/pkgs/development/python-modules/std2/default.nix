{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
}:

buildPythonPackage {
  pname = "std2";
  version = "0-unstable-2025-02-06";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ms-jpq";
    repo = "std2";
    rev = "47fda91f8c8db9d5a8faa6f55d739d74afffc440";
    hash = "sha256-n+6FxVQjzYhjQMJr+i+D8uSiVjI7HFkegxy5keVjKGs=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "std2" ];

  meta = {
    homepage = "https://github.com/ms-jpq/std2";
    description = "Dependency to chadtree and coq_nvim plugins";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
