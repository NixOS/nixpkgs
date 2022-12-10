{ lib, python3Packages, fetchFromGitHub, git }:

python3Packages.buildPythonApplication rec {
  pname = "git-delete-merged-branches";
  version = "7.2.2";

  src = fetchFromGitHub {
    owner = "hartwork";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-Q83s0kkrArRndxQa+V+eZw+iaJje7VR+aPScB33l1W0=";
  };

  propagatedBuildInputs = with python3Packages; [
    colorama
    prompt-toolkit
  ];

  checkInputs = [ git ]
    ++ (with python3Packages; [ parameterized ]);

  meta = with lib; {
    description = "Command-line tool to delete merged Git branches";
    homepage = "https://pypi.org/project/git-delete-merged-branches/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
