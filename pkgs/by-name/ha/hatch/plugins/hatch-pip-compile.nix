{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  hatchling,
  click,
  hatch,
  pip-tools,
  rich,
}:
buildPythonPackage rec {
  pname = "hatch-pip-compile";
  version = "1.11.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "juftin";
    repo = "hatch-pip-compile";
    rev = "refs/tags/v${version}";
    hash = "sha256-yZNkrdZJfFi8fdetG1Us6O5Yf+/ovWFJuRiIbjWHneE=";
  };

  build-system = [ hatchling ];

  dependencies = [
    click
    hatch
    pip-tools
    rich
  ];

  meta = {
    description = "hatch plugin to use pip-compile (or uv) to manage project dependencies and lockfiles";
    homepage = "http://juftin.com/hatch-pip-compile/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
