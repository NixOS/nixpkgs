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

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'networkx = "^2.8.4"' 'networkx = "*"' \
      --replace 'netaddr = "^0.8.0"' 'netaddr = "*"'
  '';

  nativeBuildInputs = [
    python3.pkgs.poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
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

  pythonImportsCheck = [
    "das"
  ];

  meta = with lib; {
    description = "Divide full port scan results and use it for targeted Nmap runs";
    homepage = "https://github.com/snovvcrash/DivideAndScan";
    license = licenses.bsd2;
    maintainers = with maintainers; [ fab ];
    mainProgram = "das";
  };
}
