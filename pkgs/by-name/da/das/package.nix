{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "das";
  version = "1.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snovvcrash";
    repo = "DivideAndScan";
    tag = "v${version}";
    hash = "sha256-WZmWpcBqxsNH96nVWwoepFhsvdxZpYKmAjNd7ghIJMA=";
  };

  pythonRelaxDeps = [
    "dash"
    "defusedxml"
    "netaddr"
    "networkx"
    "plotly"
  ];

  build-system = with python3Packages; [ poetry-core ];

  dependencies = with python3Packages; [
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

  nativeCheckInputs = [
    versionCheckHook
  ];

  meta = {
    description = "Divide full port scan results and use it for targeted Nmap runs";
    homepage = "https://github.com/snovvcrash/DivideAndScan";
    changelog = "https://github.com/snovvcrash/DivideAndScan/releases/tag/v${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "das";
  };
}
