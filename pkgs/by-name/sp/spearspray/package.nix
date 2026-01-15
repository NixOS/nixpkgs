{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication {
  pname = "spearspray";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sikumy";
    repo = "spearspray";
    rev = "bccb64fb672e503d2c8bf8997feb46b5ed60f3d1";
    hash = "sha256-6CSVWUOdpv7GyD8qoTbQAqqf6GHitifsV0n5GOuFawU=";
  };

  pythonRelaxDeps = [ "neo4j" ];

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    argcomplete
    colorama
    gssapi
    ldap3
    neo4j
    questionary
    unidecode
  ];

  pythonImportsCheck = [ "spearspray" ];

  # Project has no tests
  doCheck = false;

  meta = {
    description = "Tool for doing Password Spraying with User Intelligence";
    homepage = "https://github.com/sikumy/spearspray";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "spearspray";
  };
}
