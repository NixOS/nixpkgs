{ fetchFromGitLab, lib, python3Packages, qt5 }:

let
  pname = "amphetype";
  version = "1.0.0";
in python3Packages.buildPythonApplication {
  inherit pname version;

  src = fetchFromGitLab {
    owner = "franksh";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-pve2f+XMfFokMCtW3KdeOJ9Ey330Gwv/dk1+WBtrBEQ=";
  };

  propagatedBuildInputs = with python3Packages; [
    editdistance
    pyqt5
    translitcodec
  ];

  doCheck = false;

  nativeBuildInputs = [ qt5.wrapQtAppsHook ];

  meta = with lib; {
    description = "An advanced typing practice program";
    homepage = "https://gitlab.com/franksh/amphetype";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ rycee ];
  };
}
