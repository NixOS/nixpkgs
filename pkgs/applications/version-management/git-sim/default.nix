{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "git-sim";
  version = "0.2.7";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "initialcommit-com";
    repo = "git-sim";
    rev = "v${version}";
    sha256 = "sha256-Ik+KVC1JnOWYODtlIMHG0e7JP3PKB02UrhQEPGYlabo=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace '"opencv-python-headless",' "" \
      --replace '"git-dummy",' "" \
      --replace '"git-dummy=git_dummy.__main__:app",' ""
  '';

  propagatedBuildInputs = with python3.pkgs; [
    gitpython
    manim
    opencv4
    typer
    pydantic
  ];

  # ModuleNotFoundError: No module named 'git_sim.git_sim'
  # also requires extra package git-dummy and had in previous version problems when run without xserver
  doCheck = false;

  checkPhase = ''
    python test.py
  '';

  meta = with lib; {
    description = "Visually simulate Git operations in your own repos with a single terminal command";
    homepage = "https://initialcommit.com/tools/git-sim";
    downloagPage = "https://github.com/initialcommit-com/git-sim";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
