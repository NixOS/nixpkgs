{
  lib,
  python3,
  fetchFromGitHub,
  digital,
}:

python3.pkgs.buildPythonApplication {
  pname = "autograder";
  version = "0-unstable-2025-04-09";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "phpeterson-usf";
    repo = "autograder";
    rev = "6e4b410f7cb7d676994b404dadf2654a6dafe81f";
    hash = "sha256-SPWK9CqOsaCtXWGFWIWRdENmvC4lE7p01E1d2P4rAWc=";
  };

  build-system = with python3.pkgs; [
    setuptools
    wheel
  ];

  dependencies = with python3.pkgs; [
    certifi
    charset-normalizer
    idna
    requests
    tomlkit
    urllib3
  ];

  patches = [
    ./0000-setuptools.patch
    ./0001-no-pin.patch
  ];

  postPatch = ''
    # Ensure setuptools recognizes `grade` as a Python module
    mv grade grade.py

    # patch digital JAR path
    substituteInPlace actions/test.py \
      --replace-fail '~/Digital/Digital.jar' '${lib.getBin digital}/share/java/Digital.jar'
  '';

  pythonImportsCheck = [
    "grade"
    "actions"
  ];

  meta = {
    description = "Clone and build repos from Github Classroom";
    longDescription = ''
      `grade` is a tool for Computer Science students and instructors
      to test student projects for correctness.
    '';
    homepage = "https://github.com/phpeterson-usf/autograder";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "grade";
  };
}
