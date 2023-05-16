{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gitless";
<<<<<<< HEAD
  version = "0.9.17";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "goldstar611";
    repo = pname;
    rev = version;
    hash = "sha256-XDB1i2b1reMCM6i1uK3IzTnsoLXO7jldYtNlYUo1AoQ=";
=======
  version = "0.8.8";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "gitless-vcs";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-xo5EWtP2aN8YzP8ro3bnxZwUGUp0PHD0g8hk+Y+gExE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ python3.pkgs.pythonRelaxDepsHook ];

  propagatedBuildInputs = with python3.pkgs; [
<<<<<<< HEAD
    pygit2
    argcomplete
=======
    sh
    pygit2
    clint
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
