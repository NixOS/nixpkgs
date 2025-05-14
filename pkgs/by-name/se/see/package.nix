{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication {
  pname = "see";
  version = "unstable-2023-03-19";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Textualize";
    repo = "textualize-see";
    rev = "eef61dd348178ec60c5b0a01062e0b621eb57315";
    hash = "sha256-SqjDHcFKWbk4ouWkhGohDl5kGjM/9fzqFDexVcaY1gw=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    click
    colorama
    toml
  ];

  meta = {
    description = "CLI tool to open files in the terminal";
    homepage = "https://github.com/Textualize/textualize-see";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "see";
  };
}
