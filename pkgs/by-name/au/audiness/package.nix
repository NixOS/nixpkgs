{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "audiness";
  version = "0.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "audiusGmbH";
    repo = "audiness";
    tag = version;
    hash = "sha256-+5NDea4p/JWEk305EhAtab3to36a74KR50eosw6c5qI=";
  };

  pythonRelaxDeps = [
    "typer"
    "validators"
  ];

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    pytenable
    typer
    validators
  ];

  pythonImportsCheck = [ "audiness" ];

  meta = {
    description = "CLI tool to interact with Nessus";
    homepage = "https://github.com/audiusGmbH/audiness";
    changelog = "https://github.com/audiusGmbH/audiness/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "audiness";
  };
}
