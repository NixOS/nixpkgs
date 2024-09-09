{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sploitscan";
  version = "0.10.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "xaitax";
    repo = "SploitScan";
    rev = "refs/tags/v${version}";
    hash = "sha256-41NR31x/pJttBxv66t5g3s2PwlSBgsk0ybiH7xFs18k=";
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

  meta = with lib; {
    description = "Cybersecurity utility designed to provide detailed information on vulnerabilities and associated exploits";
    homepage = "https://github.com/xaitax/SploitScan";
    changelog = "https://github.com/xaitax/SploitScan/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "sploitscan";
  };
}
