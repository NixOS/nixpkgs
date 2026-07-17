{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication {
  pname = "pywhisker";
  version = "0.1.0-unstable-2025-09-16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ShutdownRepo";
    repo = "pywhisker";
    rev = "dc35dba57bb4ad594f052d6598a855d192a37a3f";
    hash = "sha256-dXr/Vb7h+ZiO5VeOEx3tfXUq8sldrRofK5ENJDZcAb0=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    cryptography
    dsinternals
    impacket
    ldap3
    ldapdomaindump
    pyasn1
    rich
    six
  ];

  pythonImportsCheck = [ "pywhisker" ];

  # Project has no tests
  doCheck = false;

  meta = {
    description = "Tool for Shadow Credentials attacks";
    homepage = "https://github.com/ShutdownRepo/pywhisker";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pywhisker";
  };
}
