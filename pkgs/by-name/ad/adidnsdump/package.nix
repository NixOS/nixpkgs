{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "adidnsdump";
  version = "1.3.1-unstable-2023-12-13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "dirkjanm";
    repo = "adidnsdump";
    rev = "8bbb4b05b2d1b792f3c77ce0a4a762ab9e08727d";
    hash = "sha256-dIbnUyV3gdWHHoyzD0ME2fXlMoiQkdrqQ7qQ6Ab6qs0=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
    impacket
    ldap3
  ];

  pythonImportsCheck = [
    "adidnsdump"
  ];

  meta = with lib; {
    description = "Active Directory Integrated DNS dumping by any authenticated user";
    homepage = "https://github.com/dirkjanm/adidnsdump";
    changelog = "https://github.com/dirkjanm/adidnsdump/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "adidnsdump";
  };
}
