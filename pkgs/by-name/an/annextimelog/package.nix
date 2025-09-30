{
  lib,
  python3,
  fetchFromGitLab,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "annextimelog";
  version = "0.15.0";
  format = "pyproject";

  src = fetchFromGitLab {
    owner = "nobodyinperson";
    repo = "annextimelog";
    tag = "v${version}";
    hash = "sha256-RfqBtbfArFva3TVJGF4STx0QTio62qxXaM23lsLYLUg=";
  };

  pythonRelaxDeps = [ "rich" ];

  nativeBuildInputs = with python3.pkgs; [
    unittestCheckHook
    setuptools
    wheel
    poetry-core
    tzdata
  ];

  unittestFlags = [ "-vb" ];

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
