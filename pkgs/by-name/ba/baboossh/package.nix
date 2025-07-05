{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "baboossh";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cybiere";
    repo = "baboossh";
    tag = "v${version}";
    hash = "sha256-E/a6dL6BpQ6D8v010d8/qav/fkxpCYNvSvoPAZsm0Hk=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    cmd2
    paramiko
    python-libnmap
    tabulate
  ];

  # No tests available
  doCheck = false;

  pythonImportsCheck = [ "baboossh" ];

  meta = {
    description = "Tool to do SSH spreading";
    homepage = "https://github.com/cybiere/baboossh";
    changelog = "https://github.com/cybiere/baboossh/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "baboossh";
  };
}
