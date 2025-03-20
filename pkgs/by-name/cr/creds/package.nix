{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "creds";
  version = "0.5.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ihebski";
    repo = "DefaultCreds-cheat-sheet";
    tag = "creds-v${version}";
    hash = "sha256-CtwGSF3EGcPqL49paNRCsB2qxYjKpCLqyRsC67nAyVk=";
  };

  pythonRelaxDeps = [ "tinydb" ];
  pythonRemoveDeps = [ "pathlib" ];

  postPatch = ''
    substituteInPlace creds \
      --replace "pathlib.Path(__file__).parent" "pathlib.Path.home()"
  '';

  propagatedBuildInputs = with python3.pkgs; [
    fire
    prettytable
    requests
    tinydb
  ];

  # Project has no tests
  doCheck = false;

  meta = with lib; {
    description = "Tool to search a collection of default credentials";
    mainProgram = "creds";
    homepage = "https://github.com/ihebski/DefaultCreds-cheat-sheet";
    changelog = "https://github.com/ihebski/DefaultCreds-cheat-sheet/releases/tag/creds-${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
