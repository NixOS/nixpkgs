{
  copyDesktopItems,
  fetchFromGitLab,
  lib,
  makeDesktopItem,
  python3Packages,
  qt5,
}:

let
  pname = "amphetype";
  version = "1.0.0";
  description = "An advanced typing practice program";
in
python3Packages.buildPythonApplication {
  inherit pname version;

  src = fetchFromGitLab {
    owner = "franksh";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-pve2f+XMfFokMCtW3KdeOJ9Ey330Gwv/dk1+WBtrBEQ=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    qt5.qtbase
    qt5.qtwayland
  ];

  propagatedBuildInputs = with python3Packages; [
    editdistance
    pyqt5
    translitcodec
  ];

  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  doCheck = false;

  desktopItems = [
    (makeDesktopItem {
      name = pname;
      desktopName = "Amphetype";
      genericName = "Typing Practice";
      categories = [
        "Education"
        "Qt"
      ];
      exec = pname;
      comment = description;
    })
  ];

  meta = with lib; {
    inherit description;
    mainProgram = "amphetype";
    homepage = "https://gitlab.com/franksh/amphetype";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ rycee ];
  };
}
