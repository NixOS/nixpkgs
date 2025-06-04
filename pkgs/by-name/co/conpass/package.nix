{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "conpass";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "login-securite";
    repo = "conpass";
    tag = "v${version}";
    hash = "sha256-7o4aQ6qpaWimWqgFO35Wht7mQsdVezoPTm7hp54FWR8=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    impacket
    python-ldap
    rich
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "conpass" ];

  meta = {
    description = "Continuous password spraying tool";
    homepage = "https://github.com/login-securite/conpass";
    changelog = "https://github.com/login-securite/conpass/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "conpass";
  };
}
