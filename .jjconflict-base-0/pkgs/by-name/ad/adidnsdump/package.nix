{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "adidnsdump";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dirkjanm";
    repo = "adidnsdump";
    tag = "v${version}";
    hash = "sha256-gKOIZuXYm8ltaajmOZXulPX5dI4fWz4xiZ8W0kPpcRk=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    impacket
    ldap3
  ];

  pythonImportsCheck = [ "adidnsdump" ];

  meta = with lib; {
    description = "Active Directory Integrated DNS dumping by any authenticated user";
    homepage = "https://github.com/dirkjanm/adidnsdump";
    changelog = "https://github.com/dirkjanm/adidnsdump/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "adidnsdump";
  };
}
