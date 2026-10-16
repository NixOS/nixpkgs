{
  lib,
  fetchFromGitHub,
  python3Packages,
  git,
}:

python3Packages.buildPythonApplication {
  pname = "git-bars";
  version = "0-unstable-2023-08-20";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "knadh";
    repo = "git-bars";
    rev = "8c935c75844512553ae50e396181c422504516d7";
    hash = "sha256-aGvioTurv0OPwpBib5O+Nytt6WZqwylhTZHYk5qmCEo=";
  };

  build-system = [ python3Packages.setuptools ];

  dependencies = [
    git
    python3Packages.setuptools
  ];

  meta = {
    homepage = "https://github.com/knadh/git-bars";
    description = "Utility for visualising git commit activity as bars on the terminal";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.matthiasbeyer ];
    mainProgram = "git-bars";
  };
}
