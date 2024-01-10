{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pysentation";
  version = "1.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "mimseyedi";
    repo = "pysentation";
    rev = "v${version}";
    hash = "sha256-TwHDXWgGWuQVgatBDc1iympnb6dy4xYThLR5MouEZHA=";
  };

  nativeBuildInputs = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  propagatedBuildInputs = with python3.pkgs; [
    click
    getkey
    rich
  ];

  pythonImportsCheck = [ "pysentation" ];

  meta = with lib; {
    description = "A CLI for displaying Python presentations";
    homepage = "https://github.com/mimseyedi/pysentation";
    changelog = "https://github.com/mimseyedi/pysentation/releases/tag/${src.rev}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "pysentation";
  };
}
