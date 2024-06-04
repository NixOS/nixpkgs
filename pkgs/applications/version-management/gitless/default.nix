{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gitless";
  version = "0.9.17";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "goldstar611";
    repo = pname;
    rev = version;
    hash = "sha256-XDB1i2b1reMCM6i1uK3IzTnsoLXO7jldYtNlYUo1AoQ=";
  };

  nativeBuildInputs = [ python3.pkgs.pythonRelaxDepsHook ];

  propagatedBuildInputs = with python3.pkgs; [
    pygit2
    argcomplete
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
    mainProgram = "gl";
  };
}
