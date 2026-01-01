{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "creds";
  version = "0.5.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "ihebski";
    repo = "DefaultCreds-cheat-sheet";
    tag = "creds-v${version}";
    hash = "sha256-nATmzEUwvJwzPZs+bO+/6ZHIrGgvjApaEwVpMyCXmik=";
  };

  pythonRelaxDeps = [ "tinydb" ];
  pythonRemoveDeps = [ "pathlib" ];

  postPatch = ''
    substituteInPlace creds \
      --replace-fail "pathlib.Path(__file__).parent" "pathlib.Path.home()"
  '';

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    fire
    prettytable
    requests
    tinydb
  ];

  # Project has no tests
  doCheck = false;

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Tool to search a collection of default credentials";
    mainProgram = "creds";
    homepage = "https://github.com/ihebski/DefaultCreds-cheat-sheet";
    changelog = "https://github.com/ihebski/DefaultCreds-cheat-sheet/releases/tag/${src.tag}";
<<<<<<< HEAD
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
