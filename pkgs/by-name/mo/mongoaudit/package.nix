{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "mongoaudit";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stampery";
    repo = "mongoaudit";
    tag = finalAttrs.version;
    hash = "sha256-RZBAldCHl7ApYQWhuvs/djhGWuQ+EdpVMCnP0QrfZJ4=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    pymongo
    setuptools
    urwid
  ];

  nativeCheckInputs = with python3.pkgs; [ pytestCheckHook ];

  pythonImportsCheck = [ "mongoaudit" ];

  meta = {
    description = "MongoDB auditing and pentesting tool";
    homepage = "https://github.com/stampery/mongoaudit";
    changelog = "https://github.com/stampery/mongoaudit/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "mongoaudit";
  };
})
