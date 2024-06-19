{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sploitscan";
  version = "0.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xaitax";
    repo = "SploitScan";
    rev = "refs/tags/v${version}";
    hash = "sha256-l2nLqQoM5TuOezobipBV+s/nXTw37xhop/xpipLL1Bs=";
  };

  pythonRelaxDeps = [
    "openai"
    "requests"
  ];

  build-system = with python3.pkgs; [
    setuptools
  ];

  nativeBuildInputs = with python3.pkgs; [ pythonRelaxDepsHook ];

  dependencies = with python3.pkgs; [
    jinja2
    openai
    requests
  ];

  pythonImportsCheck = [ "sploitscan" ];

  meta = with lib; {
    description = "Cybersecurity utility designed to provide detailed information on vulnerabilities and associated exploits";
    homepage = "https://github.com/xaitax/SploitScan";
    changelog = "https://github.com/xaitax/SploitScan/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "sploitscan";
  };
}
