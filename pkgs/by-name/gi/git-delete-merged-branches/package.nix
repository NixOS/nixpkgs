{
  lib,
  python3Packages,
  fetchFromGitHub,
  git,
}:

python3Packages.buildPythonApplication rec {
  pname = "git-delete-merged-branches";
  version = "7.4.1";

  src = fetchFromGitHub {
    owner = "hartwork";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-1CUwac2TPU5s1uLS1zPvtXZEGCWYwm1y935jqbI173Q=";
  };

  propagatedBuildInputs = with python3Packages; [
    colorama
    prompt-toolkit
  ];

  nativeCheckInputs = [ git ] ++ (with python3Packages; [ parameterized ]);

  meta = with lib; {
    description = "Command-line tool to delete merged Git branches";
    homepage = "https://pypi.org/project/git-delete-merged-branches/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
