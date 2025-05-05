{
  buildPythonPackage,
  fetchPypi,
  lib,

  pathspec,
  setuptools,
  tree-sitter-language-pack,
}:

buildPythonPackage rec {
  pname = "grep-ast";
  version = "0.8.1";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "grep_ast";
    hash = "sha256-j68oX0QEKvR9xqRfHh+AKYZgSFY9dYpxmwU5ytJkGH8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pathspec
    tree-sitter-language-pack
  ];

  # Tests disabled due to pending update from tree-sitter-languages to tree-sitter-language-pack
  # nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "grep_ast" ];

  meta = {
    homepage = "https://github.com/paul-gauthier/grep-ast";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ greg ];
    description = "Python implementation of the ast-grep tool";
    mainProgram = "grep-ast";
  };
}
