{ lib
, fetchFromGitHub
, graphviz
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "route-graph";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "audiusGmbH";
    repo = "route-graph";
    rev = "refs/tags/${version}";
    hash = "sha256-sIUuy3J7wsxyTZ1XPSmQcDdoqfE+yKHqFKbYlwk7/j4=";
  };

  pythonRelaxDeps = [
    "typing-extensions"
  ];

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    graphviz
  ] ++ (with python3.pkgs; [
    scapy
    typer
    typing-extensions
  ] ++ typer.optional-dependencies.all);

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "route_graph"
  ];

  meta = with lib; {
    description = "CLI tool for creating graphs of routes";
    homepage = "https://github.com/audiusGmbH/route-graph";
    changelog = "https://github.com/audiusGmbH/route-graph/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "route-graph";
  };
}
