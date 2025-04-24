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
    rev = "refs/tags/${version}";
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

  meta = with lib; {
    description = "Web Content Discovery Tool";
    homepage = "https://github.com/deibit/cansina";
    changelog = "https://github.com/deibit/cansina/blob/${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "cansina";
  };
}
