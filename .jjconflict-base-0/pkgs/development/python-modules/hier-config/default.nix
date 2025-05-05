{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pydantic,
  pytestCheckHook,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "hier-config";
  version = "3.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "netdevops";
    repo = "hier_config";
    tag = "v${version}";
    hash = "sha256-3xSxzdIxoQgJtA3CX141jP2Zl2j8Dwfplv4JYpHpCdQ=";
  };

  build-system = [ poetry-core ];

  dependencies = [ pydantic ];

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
  ];

  pythonImportsCheck = [ "hier_config" ];

  meta = {
    description = "Module to handle hierarchical configurations";
    homepage = "https://github.com/netdevops/hier_config";
    changelog = "https://github.com/netdevops/hier_config/releases/tag/v${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
