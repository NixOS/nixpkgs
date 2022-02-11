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

  propagatedBuildInputs = with python3.pkgs; [
    sh
    pygit2
    clint
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pygit2==0.28.2" "pygit2>=0.28.2"
  '';

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
