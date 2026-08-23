{
  lib,
  fetchFromGitHub,
  python3Packages,
  exegol,
}:
python3Packages.buildPythonApplication rec {
  pname = "exegol-mcp";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ThePorgs";
    repo = "Exegol-MCP";
    tag = version;
    hash = "sha256-A8mF6EJps7IUhgrk1Y6vic6JlS0bpxTq7CL1NEuC4qk=";
  };

  build-system = with python3Packages; [ pdm-backend ];

  dependencies =
    with python3Packages;
    [
      mcp
    ]
    ++ [ exegol ];

  doCheck = true;

  pythonImportsCheck = [ "exegol_mcp" ];

  meta = {
    description = "MCP server for Exegol";
    homepage = "https://github.com/ThePorgs/Exegol-MCP";
    changelog = "https://github.com/ThePorgs/Exegol-MCP/releases/tag/${src.tag}";
    license = with lib.licenses; [
      gpl3Only
      {
        fullName = "Exegol Software License (ESL) - Version 1.0";
        url = "https://docs.exegol.com/legal/software-license";
        free = false;
        redistributable = false;
      }
    ];
    mainProgram = "exegol-mcp";
    maintainers = with lib.maintainers; [
      macbucheron
    ];
  };
}
