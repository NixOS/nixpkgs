{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "conpass";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "login-securite";
    repo = "conpass";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EXmmLL2z/jG3ThIyOXnJbYoorOg40HRhJ/74hN44NO4=";
  };

  build-system = with python3.pkgs; [ hatchling ];

  dependencies = with python3.pkgs; [
    impacket
    python-ldap
    rich
    typer
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "conpass" ];

  meta = {
    description = "Continuous password spraying tool";
    homepage = "https://github.com/login-securite/conpass";
    changelog = "https://github.com/login-securite/conpass/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "conpass";
  };
})
