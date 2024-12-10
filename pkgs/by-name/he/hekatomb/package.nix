{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "hekatomb";
  version = "1.5.14-unstable-2024-02-14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ProcessusT";
    repo = "HEKATOMB";
    rev = "8cd372fd5d93e8b43c2cbe2ab2cada635f00e9dd";
    hash = "sha256-2juP2SuCfY4z2J27BlodrsP+29BjGxKDIDOW0mmwCPY=";
  };

  pythonRelaxDeps = [
    "impacket"
  ];

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    chardet
    dnspython
    impacket
    ldap3
    pycryptodomex
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "hekatomb"
  ];

  meta = with lib; {
    description = "Tool to connect to LDAP directory to retrieve informations";
    homepage = "https://github.com/ProcessusT/HEKATOMB";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "hekatomb";
  };
}
