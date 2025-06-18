{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "smbmap";
  version = "1.10.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ShawnDEvans";
    repo = "smbmap";
    tag = "v${version}";
    hash = "sha256-HF1O9iX1rqAVegHFkBychoMta04uEzN3gkIF4StgggQ=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    impacket
    pyasn1
    pycrypto
    configparser
    termcolor
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "smbmap" ];

  meta = {
    description = "SMB enumeration tool";
    homepage = "https://github.com/ShawnDEvans/smbmap";
    changelog = "https://github.com/ShawnDEvans/smbmap/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "smbmap";
  };
}
