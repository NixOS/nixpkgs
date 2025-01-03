{
  lib,
  fetchFromGitHub,
  python3,
  testers,
  mcdreforged,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mcdreforged";
  version = "2.13.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MCDReforged";
    repo = "MCDReforged";
    rev = "refs/tags/v${version}";
    hash = "sha256-Um4XSpkpJupBy5h/hUuHNyXnaDvjL1IIcmSqBHKycEM=";
  };

  build-system = [ python3.pkgs.setuptools ];

  dependencies = with python3.pkgs; [
    colorama
    colorlog
    packaging
    parse
    prompt-toolkit
    psutil
    requests
    resolvelib
    ruamel-yaml
    typing-extensions
  ];

  nativeCheckInputs = [ python3.pkgs.pytestCheckHook ];

  passthru.tests = {
    version = testers.testVersion { package = mcdreforged; };
  };

  meta = {
    description = "Rewritten version of MCDaemon, a python tool to control your Minecraft server";
    homepage = "https://mcdreforged.com";
    changelog = "https://github.com/MCDReforged/MCDReforged/releases/tag/v${version}";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "mcdreforged";
  };
}
