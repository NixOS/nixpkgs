{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sploitscan";
  version = "0.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xaitax";
    repo = "SploitScan";
    tag = "v.${version}";
    hash = "sha256-5aSEHZKTmkO/KcklMUEt2q8hqPc8XiT5QUU1YY3wmBw=";
  };

  pythonRelaxDeps = [
    "openai"
    "requests"
  ];

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    jinja2
    openai
    requests
  ];

  pythonImportsCheck = [ "sploitscan" ];

  meta = {
    description = "Cybersecurity utility designed to provide detailed information on vulnerabilities and associated exploits";
    homepage = "https://github.com/xaitax/SploitScan";
    changelog = "https://github.com/xaitax/SploitScan/releases/tag/v.${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "sploitscan";
  };
}
