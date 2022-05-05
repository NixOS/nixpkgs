{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gitless";
  version = "0.8.8";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "gitless-vcs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-xo5EWtP2aN8YzP8ro3bnxZwUGUp0PHD0g8hk+Y+gExE=";
  };

  nativeBuildInputs = [ python3.pkgs.pythonRelaxDepsHook ];

  propagatedBuildInputs = with python3.pkgs; [
    sh
    pygit2
    clint
  ];

  pythonRelaxDeps = [ "pygit2" ];

  doCheck = false;

  pythonImportsCheck = [
    "gitless"
  ];

  meta = with lib; {
    description = "Version control system built on top of Git";
    homepage = "https://gitless.com/";
    license = licenses.mit;
    maintainers = with maintainers; [ cransom ];
    platforms = platforms.all;
  };
}
