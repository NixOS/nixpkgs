{ lib, python3Packages, fetchFromGitHub, git }:

python3Packages.buildPythonApplication rec {
  pname = "git-delete-merged-branches";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "hartwork";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-CPJhd3QXXNm4RGBEDnNOohVOYKVI6I8uc3cDiTrXKvc=";
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
