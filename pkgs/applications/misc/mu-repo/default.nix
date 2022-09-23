{ lib, fetchFromGitHub, buildPythonApplication, pytestCheckHook, git }:

buildPythonApplication rec {
  pname = "mu-repo";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "fabioz";
    repo = pname;
    rev = "mu_repo_${lib.replaceStrings [ "." ] [ "_" ] version}";
    sha256 = "0mmjdkvmdlsndi2q56ybxyz2988ppxsbbr1g54nzzkkvab2bc2na";
  };

  propagatedBuildInputs = [ git ];

  checkInputs = [ pytestCheckHook git ];

  meta = with lib; {
    description = "Tool to help in dealing with multiple git repositories";
    homepage = "http://fabioz.github.io/mu-repo/";
    license = licenses.gpl3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ sikmir ];
  };
}
