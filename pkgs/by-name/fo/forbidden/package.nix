{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "forbidden";
  version = "10.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ivan-sincek";
    repo = "forbidden";
    rev = "refs/tags/v${version}";
    hash = "sha256-LggF9giKKKO2F65zS0lPCshaDauy+s6YyRGr3BL0tJU=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    colorama
    datetime
    pycurl
    pyjwt
    regex
    requests
    tabulate
    termcolor
  ];

  pythonImportsCheck = [
    "forbidden"
  ];

  meta = with lib; {
    description = "Tool to bypass 4xx HTTP response status code";
    homepage = "https://github.com/ivan-sincek/forbidden";
    changelog = "https://github.com/ivan-sincek/forbidden/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "forbidden";
  };
}
