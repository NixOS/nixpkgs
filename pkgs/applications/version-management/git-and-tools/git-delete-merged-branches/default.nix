{ lib, python3Packages, fetchFromGitHub, git }:

python3Packages.buildPythonApplication rec {
  pname = "git-delete-merged-branches";
  version = "6.4.0";

  src = fetchFromGitHub {
    owner = "hartwork";
    repo = pname;
    rev = version;
    sha256 = "sha256-swAc8ObZY78nVQyjTrVG81xBqTYnWHVDFpiUApbowqU=";
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
