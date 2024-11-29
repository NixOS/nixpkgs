{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  importlib-metadata,
  pyyaml,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "markdown";
  version = "3.7";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Python-Markdown";
    repo = "markdown";
    rev = "refs/tags/${version}";
    hash = "sha256-bIBen693MC56k4LZ+8vhbvP+E3myFXoaXpNHOlnIdG8=";
  };

  build-system = [ setuptools ];

  dependencies = lib.optionals (pythonOlder "3.10") [ importlib-metadata ];

  nativeCheckInputs = [
    unittestCheckHook
    pyyaml
  ];

  pythonImportsCheck = [ "markdown" ];

  meta = with lib; {
    changelog = "https://github.com/Python-Markdown/markdown/blob/${src.rev}/docs/changelog.md";
    description = "Python implementation of John Gruber's Markdown";
    mainProgram = "markdown_py";
    homepage = "https://github.com/Python-Markdown/markdown";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dotlambda ];
  };
}
