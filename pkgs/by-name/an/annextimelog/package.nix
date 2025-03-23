{
  lib,
  python3,
  fetchFromGitLab,
  fetchPypi,
}:

let
  tzdata = python3.pkgs.tzdata.overrideAttrs rec {
    version = "2023.4";

    src = fetchPypi {
      pname = "tzdata";
      inherit version;
      hash = "sha256-3VTJTylHZVIsdzmWSbT+/ZVSJHmmZKDOyH9BvrxhSMk=";
    };
  };
in
python3.pkgs.buildPythonApplication rec {
  pname = "annextimelog";
  version = "0.14.0";
  format = "pyproject";

  src = fetchFromGitLab {
    owner = "nobodyinperson";
    repo = "annextimelog";
    rev = "v${version}";
    hash = "sha256-+3PkG33qKckagSVvVdqkypulO7uu5AMOv8fQiP8IUbs=";
  };

  nativeBuildInputs = with python3.pkgs; [
    setuptools
    wheel
    poetry-core
  ] ++ [ tzdata ];

  propagatedBuildInputs = with python3.pkgs; [
    rich
  ];

  meta = with lib; {
    description = "git-annex based cli time tracker";
    homepage = "https://gitlab.com/nobodyinperson/annextimelog";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
