{
<<<<<<< HEAD
  lib,
  copyDesktopItems,
  fetchFromGitLab,
=======
  copyDesktopItems,
  fetchFromGitLab,
  lib,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  makeDesktopItem,
  python3Packages,
  qt5,
}:

let
  pname = "amphetype";
  version = "1.0.0";
  description = "Advanced typing practice program";
in
python3Packages.buildPythonApplication {
  format = "pyproject";
  inherit pname version;

  src = fetchFromGitLab {
    owner = "franksh";
    repo = "amphetype";
    tag = "v${version}";
    hash = "sha256-pve2f+XMfFokMCtW3KdeOJ9Ey330Gwv/dk1+WBtrBEQ=";
  };

  nativeBuildInputs = [
    copyDesktopItems
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
<<<<<<< HEAD
=======
    qt5.qtbase
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    qt5.qtwayland
  ];

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    editdistance
    pyqt5
    translitcodec
  ];

<<<<<<< HEAD
  makeWrapperArgs = [
    "\${qtWrapperArgs[@]}"
  ];

  # no tests
=======
  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  doCheck = false;

  desktopItems = [
    (makeDesktopItem {
      name = "amphetype";
      desktopName = "Amphetype";
      genericName = "Typing Practice";
      categories = [
        "Education"
        "Qt"
      ];
      exec = "amphetype";
      comment = description;
    })
  ];

<<<<<<< HEAD
  meta = {
    inherit description;
    mainProgram = "amphetype";
    homepage = "https://gitlab.com/franksh/amphetype";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ rycee ];
=======
  meta = with lib; {
    inherit description;
    mainProgram = "amphetype";
    homepage = "https://gitlab.com/franksh/amphetype";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ rycee ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
