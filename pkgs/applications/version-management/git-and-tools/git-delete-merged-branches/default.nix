{ lib, python3Packages, fetchFromGitHub, git }:

python3Packages.buildPythonApplication rec {
  pname = "git-delete-merged-branches";
  version = "6.3.0";

  src = fetchFromGitHub {
    owner = "hartwork";
    repo = pname;
    rev = version;
    sha256 = "sha256-mUgSIwU39BT0bCA2UQANe2Yzkgl2xAmXQQ9P2bLoEMc=";
  };

  propagatedBuildInputs = with python3Packages; [
    colorama
    clintermission
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
