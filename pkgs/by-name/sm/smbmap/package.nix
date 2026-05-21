{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "smbmap";
  version = "1.10.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ShawnDEvans";
    repo = "smbmap";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jJDDrHBZWlDOQ/gI6x2Vy+ljXm+9lcBIt8XG/npNa6M=";
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
    changelog = "https://github.com/ShawnDEvans/smbmap/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "smbmap";
  };
})
