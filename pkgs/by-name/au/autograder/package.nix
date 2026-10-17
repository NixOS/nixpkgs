{
  lib,
  python3Packages,
  fetchFromGitHub,
  digital,
}:

python3Packages.buildPythonApplication {
  pname = "autograder";
  version = "0-unstable-2026-08-02";
  __structuredAttrs = true;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "phpeterson-usf";
    repo = "autograder";
    rev = "edc021a2c85cc0309d67effaee692733cbf72b1e";
    hash = "sha256-nF1WIaX1FVYox8kwbD81mZi6wbgwLPnMiRu9WE1MQrY=";
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
