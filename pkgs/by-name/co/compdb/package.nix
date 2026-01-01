{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "compdb";
  version = "0.2.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Sarcasm";
    repo = "compdb";
    rev = "v${version}";
    sha256 = "sha256-nFAgTrup6V5oE+LP4UWDOCgTVCv2v9HbQbkGW+oDnTg=";
  };

  build-system = with python3.pkgs; [
    setuptools
  ];

<<<<<<< HEAD
  meta = {
    description = "Command line tool to manipulate compilation databases";
    license = lib.licenses.mit;
    homepage = "https://github.com/Sarcasm/compdb";
    maintainers = [ lib.maintainers.detegr ];
=======
  meta = with lib; {
    description = "Command line tool to manipulate compilation databases";
    license = licenses.mit;
    homepage = "https://github.com/Sarcasm/compdb";
    maintainers = [ maintainers.detegr ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "compdb";
  };
}
