{
  lib,
  python3Packages,
  fetchFromGitHub,
  digital,
}:

python3Packages.buildPythonApplication {
  pname = "autograder";
  version = "0-unstable-2025-09-09";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "phpeterson-usf";
    repo = "autograder";
    rev = "91a80d59b750a9e0454d4a0329d9cfd0739f3f27";
    hash = "sha256-F1q50QS8LdIdceRa/a7FCseXvyPYbI+nl7cyPuSUpfM=";
  };

  build-system = with python3Packages; [
    setuptools
    wheel
  ];

  dependencies = with python3Packages; [
    certifi
    charset-normalizer
    idna
    requests
    tomlkit
    urllib3
    autopep8
    pep8
    pylint
    simple-term-menu
    pytest
  ];

  # patch digital JAR path
  postPatch = ''
    substituteInPlace src/autograder/actions/test.py \
      --replace-fail '~/Digital/Digital.jar' '${lib.getBin digital}/share/java/Digital.jar'
  '';

  pythonImportsCheck = [ "autograder" ];

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
