{
  lib,
  fetchFromGitHub,
  python3,
  testers,
  mcdreforged,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mcdreforged";
  version = "2.12.3";

  src = fetchFromGitHub {
    owner = "Fallen-Breath";
    repo = "MCDReforged";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-MLub++mkkB/jshpHJXtqgIhs7Gcb4jHUyHqGE65S8A8=";
  };

  disabled = python3.pkgs.pythonOlder "3.8";

  build-system = [ python3.pkgs.setuptools ];

  dependencies = with python3.pkgs; [
    colorlog
    colorama
    packaging
    parse
    prompt-toolkit
    psutil
    ruamel-yaml
    typing-extensions
  ];

  nativeCheckInputs = [ python3.pkgs.pytestCheckHook ];

  passthru.tests = {
    version = testers.testVersion { package = mcdreforged; };
  };

  meta = with lib; {
    description = "A rewritten version of MCDaemon, a python tool to control your Minecraft server";
    homepage = "https://mcdreforged.com";
    changelog = "https://github.com/MCDReforged/MCDReforged/releases/tag/v${version}";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ moraxyc ];
    mainProgram = "mcdreforged";
  };
}
