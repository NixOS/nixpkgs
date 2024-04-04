{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "krbjack";
  version = "0-unstable-2024-02-08";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "almandin";
    repo = "krbjack";
    rev = "0abaf7039c11fe735120c44a9420a311b42f7551";
    hash = "sha256-rvK0I8WlXqJtau9f+6ximfzYCjX21dPIyDN56IMI0gE=";
  };

  pythonRelaxDeps = [
    "impacket"
  ];

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
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
    license = licenses.beerware;
    maintainers = with maintainers; [ fab ];
    mainProgram = "krbjack";
  };
}
