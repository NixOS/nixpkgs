{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication rec {
  pname = "cursewords";
  version = "1.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "thisisparker";
    repo = "cursewords";
    rev = "v${version}";
    hash = "sha256-Ssr15kSdWmyMFFG5uCregrpGQ3rI2cMXqY9+/a3gs84=";
  };

  nativeBuildInputs = [
    python3Packages.setuptools
    python3Packages.wheel
  ];

  doCheck = false; # no tests

  propagatedBuildInputs = [
    python3Packages.blessed
  ];

  meta = with lib; {
    homepage = "https://github.com/thisisparker/cursewords";
    description = "Graphical command line program for solving crossword puzzles in the terminal";
    mainProgram = "cursewords";
    license = licenses.agpl3Only;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
