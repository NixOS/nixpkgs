{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "shell-gpt";
  version = "1.4.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TheR1D";
    repo = "shell_gpt";
    rev = "refs/tags/${version}";
    hash = "sha256-T37L4U1kOrrIQJ2znq2UupD3pyit9xd8rAsEwUvGiQ8=";
  };

  pythonRelaxDeps = [
    "requests"
    "rich"
    "distro"
    "typer"
    "instructor"
  ];

  build-system = with python3.pkgs; [ hatchling ];


  propagatedBuildInputs = with python3.pkgs; [
    click
    distro
    instructor
    openai
    rich
    typer
  ];

  # Tests want to read the OpenAI API key from stdin
  doCheck = false;

  meta = with lib; {
    description = "Access ChatGPT from your terminal";
    homepage = "https://github.com/TheR1D/shell_gpt";
    changelog = "https://github.com/TheR1D/shell_gpt/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ mglolenstine ];
    mainProgram = "sgpt";
  };
}
