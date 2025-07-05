{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "compdb";
  version = "0.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Sarcasm";
    repo = "compdb";
    rev = "v${version}";
    sha256 = "sha256-nFAgTrup6V5oE+LP4UWDOCgTVCv2v9HbQbkGW+oDnTg=";
  };

  meta = with lib; {
    description = "Command line tool to manipulate compilation databases";
    license = licenses.mit;
    homepage = "https://github.com/Sarcasm/compdb";
    maintainers = [ maintainers.detegr ];
    mainProgram = "compdb";
  };
}
