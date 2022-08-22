{ lib, python3Packages, fetchFromGitHub, git }:

python3Packages.buildPythonApplication rec {
  pname = "git-delete-merged-branches";
  version = "7.2.0";

  src = fetchFromGitHub {
    owner = "hartwork";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-pdP+DDJOSqr/fUQPtb84l/8J4EA81nlk/U8h24X8n+I=";
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
