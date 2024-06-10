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
    rev = "refs/tags/${version}";
    hash = "sha256-+5NDea4p/JWEk305EhAtab3to36a74KR50eosw6c5qI=";
  };

  pythonRelaxDeps = [
    "typer"
    "validators"
  ];

  build-system = with python3.pkgs; [ poetry-core ];

  nativeBuildInputs = with python3.pkgs; [ pythonRelaxDepsHook ];

  dependencies =
    with python3.pkgs;
    [
      pytenable
      typer
      validators
    ]
    ++ typer.optional-dependencies.all;

  pythonImportsCheck = [ "audiness" ];

  meta = with lib; {
    description = "CLI tool to interact with Nessus";
    homepage = "https://github.com/audiusGmbH/audiness";
    changelog = "https://github.com/audiusGmbH/audiness/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "audiness";
  };
}
