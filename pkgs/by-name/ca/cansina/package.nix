{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "cansina";
  version = "0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deibit";
    repo = "cansina";
    tag = version;
    hash = "sha256-vDlYJSRBVFtEdE/1bN8PniFYkpggIKMcEakphHmaTos=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    asciitree
    requests
  ];

  pythonImportsCheck = [
    "cansina"
  ];

  meta = {
    description = "Web Content Discovery Tool";
    homepage = "https://github.com/deibit/cansina";
    changelog = "https://github.com/deibit/cansina/blob/${version}/CHANGELOG.md";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "cansina";
  };
}
