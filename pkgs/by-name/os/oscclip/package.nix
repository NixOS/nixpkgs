{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "oscclip";
  version = "0.4.1";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "rumpelsepp";
    repo = "oscclip";
    rev = "v${version}";
    sha256 = "sha256-WQvZn+SWamEqEXPutIZVDZTIczybtHUG9QsN8XxUeg8=";
  };

  nativeBuildInputs = with python3Packages; [ poetry-core ];

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    description = "Program that allows to copy/paste from a terminal using osc-52 control sequences";
    longDescription = ''
      oscclip provides two commands: osc-copy and osc-paste. These commands allow to interact with the clipboard through the terminal directly.
      This means that they work through ssh sessions for example (given that the terminal supports osc-52 sequences).
    '';
    homepage = "https://github.com/rumpelsepp/oscclip";

<<<<<<< HEAD
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
=======
    license = licenses.gpl3Only;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      rumpelsepp
      traxys
    ];
  };
}
