{ fetchFromGitHub, python, lib }:

with python.pkgs;
buildPythonApplication rec {
  pname = "gitless";
  version = "0.8.8";

  src = fetchFromGitHub {
    owner = "gitless-vcs";
    repo = "gitless";
    rev = "v${version}";
    sha256 = "sha256-xo5EWtP2aN8YzP8ro3bnxZwUGUp0PHD0g8hk+Y+gExE=";
  };

  propagatedBuildInputs = with pythonPackages; [ sh pygit2 clint ];

  doCheck = false;

  meta = with lib; {
    homepage = "https://gitless.com/";
    description = "A version control system built on top of Git";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = [ maintainers.cransom ];
  };
}

