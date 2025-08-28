{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "forbidden";
  version = "13.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ivan-sincek";
    repo = "forbidden";
    tag = "v${version}";
    hash = "sha256-DQ8zjiLTgBBoqp8AP5BYULz4KGnVEt8e7bkfYRGWvFw=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    alive-progress
    bot-safe-agents
    colorama
    cryptography
    pycurl
    pyjwt
    regex
    requests
    tabulate
    termcolor
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "forbidden" ];

  meta = {
    description = "Tool to bypass 4xx HTTP response status code";
    homepage = "https://github.com/ivan-sincek/forbidden";
    changelog = "https://github.com/ivan-sincek/forbidden/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "forbidden";
  };
}
