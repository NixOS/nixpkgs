{ lib, python3Packages, fetchFromGitHub, git }:

python3Packages.buildPythonApplication rec {
  pname = "git-delete-merged-branches";
  version = "6.0.5";

  src = fetchFromGitHub {
    owner = "hartwork";
    repo = pname;
    rev = version;
    sha256 = "1mlmikcpm94nymid35v9rx9dyprhwidgwbdfd5zhsw502d40v0xp";
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
    license = licenses.gpl3;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
