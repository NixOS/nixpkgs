{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "krbjack";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "almandin";
    repo = "krbjack";
    rev = "refs/tags/${version}";
    hash = "sha256-rvK0I8WlXqJtau9f+6ximfzYCjX21dPIyDN56IMI0gE=";
  };

  pythonRelaxDeps = [
    "impacket"
  ];

  build-system = with python3.pkgs; [
    poetry-core
  ];

  dependencies = with python3.pkgs; [
    colorama
    dnspython
    impacket
    scapy
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "krbjack"
  ];

  meta = with lib; {
    description = "Kerberos AP-REQ hijacking tool with DNS unsecure updates abuse";
    homepage = "https://github.com/almandin/krbjack";
    changelog = "https://github.com/almandin/krbjack/releases/tag/${version}}";
    license = licenses.beerware;
    maintainers = with maintainers; [ fab ];
    mainProgram = "krbjack";
  };
}
