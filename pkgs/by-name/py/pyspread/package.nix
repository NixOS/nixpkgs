{
  lib,
  python3Packages,
  fetchPypi,
  copyDesktopItems,
  libsForQt5,
  makeDesktopItem,
}:

let
  inherit (libsForQt5)
    qtsvg
    wrapQtAppsHook
    ;
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pyspread";
  version = "2.4";

  src = fetchPypi {
    pname = "pyspread";
    inherit (finalAttrs) version;
    hash = "sha256-MZlR2Rap5oMRfCmswg9W//FYFkSEki7eyMNhLoGZgJM=";
  };

  pyproject = true;

  nativeBuildInputs = [
    copyDesktopItems
    wrapQtAppsHook
  ];

  buildInputs = [
    qtsvg
  ];

  dependencies = with python3Packages; [
    python-dateutil
    markdown2
    matplotlib
    numpy
    pyenchant
    pyqt5
  ];

  strictDeps = true;

  doCheck = true;
  pythonImportsCheck = [ "pyspread" ];

  desktopItems = [
    (makeDesktopItem {
      name = "pyspread";
      exec = "pyspread";
      icon = "pyspread";
      desktopName = "Pyspread";
      genericName = "Spreadsheet";
      comment = "Python-oriented spreadsheet application";
      categories = [
        "Office"
        "Development"
        "Spreadsheet"
      ];
    })
  ];

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = {
    homepage = "https://pyspread.gitlab.io/";
    description = "Python-oriented spreadsheet application";
    longDescription = ''
      pyspread is a non-traditional spreadsheet application that is based on and
      written in the programming language Python. The goal of pyspread is to be
      the most pythonic spreadsheet.

      pyspread expects Python expressions in its grid cells, which makes a
      spreadsheet specific language obsolete. Each cell returns a Python object
      that can be accessed from other cells. These objects can represent
      anything including lists or matrices.
    '';
    license = with lib.licenses; [ gpl3Plus ];
    mainProgram = "pyspread";
    maintainers = with lib.maintainers; [ Merikei ];
    platforms = lib.platforms.linux;
  };
})
