{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "forbidden";
  version = "12.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ivan-sincek";
    repo = "forbidden";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZxEkkg1gFs/pSAnrW85UqDQKczXqLW1q4kW58TagEA0=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    alive-progress
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
