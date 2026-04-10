{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "pysentation";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mimseyedi";
    repo = "pysentation";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TwHDXWgGWuQVgatBDc1iympnb6dy4xYThLR5MouEZHA=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
  ];

  pythonRelaxDeps = [
    "click"
    "rich"
  ];

  propagatedBuildInputs = with python3.pkgs; [
    click
    getkey
    rich
  ];

  pythonImportsCheck = [ "pysentation" ];

  meta = {
    description = "CLI for displaying Python presentations";
    homepage = "https://github.com/mimseyedi/pysentation";
    changelog = "https://github.com/mimseyedi/pysentation/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
    mainProgram = "pysentation";
  };
})
