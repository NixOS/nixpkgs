{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "das";
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snovvcrash";
    repo = "DivideAndScan";
    rev = "refs/tags/v${version}";
    hash = "sha256-WZmWpcBqxsNH96nVWwoepFhsvdxZpYKmAjNd7ghIJMA=";
  };

  pythonRelaxDeps = [
    "defusedxml"
    "netaddr"
    "networkx"
  ];

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    dash
    defusedxml
    dnspython
    netaddr
    networkx
    pandas
    plotly
    python-nmap
    scipy
    tinydb
  ];

  pythonImportsCheck = [ "das" ];

  meta = with lib; {
    description = "Divide full port scan results and use it for targeted Nmap runs";
    homepage = "https://github.com/snovvcrash/DivideAndScan";
    changelog = "https://github.com/snovvcrash/DivideAndScan/releases/tag/v${version}";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
    mainProgram = "das";
  };
}
