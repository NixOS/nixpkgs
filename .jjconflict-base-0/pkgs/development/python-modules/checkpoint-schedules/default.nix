{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  numpy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "checkpoint-schedules";
  version = "1.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "firedrakeproject";
    repo = "checkpoint_schedules";
    tag = "v${version}";
    hash = "sha256-3bn/KxxtRLRtOHFeULQdnndonpuhuYLL8/y/zoAurzY=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
  ];

  pythonImportsCheck = [
    "checkpoint_schedules"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    homepage = "https://www.firedrakeproject.org/checkpoint_schedules";
    downloadPage = "https://github.com/firedrakeproject/checkpoint_schedules";
    description = "Schedules for incremental checkpointing of adjoint simulations";
    changelog = "https://github.com/firedrakeproject/checkpoint_schedules/releases/tag/${src.tag}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ qbisi ];
  };
}
