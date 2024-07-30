{ lib
, python3
, fetchPypi
, copyDesktopItems
, libsForQt5
, makeDesktopItem
}:

let
  # get rid of rec
  pname = "pyspread";
  version = "2.2.3";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oNMDDXpl6Y0N7j+qgboSTJA9SR5KzKxhoMh/44ngjdA=";
  };
  inherit (libsForQt5)
    qtsvg
    wrapQtAppsHook;
in
python3.pkgs.buildPythonApplication {
  inherit pname version src;

  nativeBuildInputs = [
    copyDesktopItems
    wrapQtAppsHook
  ];

  buildInputs = [
    qtsvg
  ];

  propagatedBuildInputs = with python3.pkgs; [
    python-dateutil
    markdown2
    matplotlib
    numpy
    pyenchant
    pyqt5
    setuptools
  ];

  strictDeps = true;

  doCheck = false; # it fails miserably with a core dump

  pythonImportsCheck = [ "pyspread" ];

  desktopItems = [
    (makeDesktopItem {
      name = "pyspread";
      exec = "pyspread";
      icon = "pyspread";
      desktopName = "Pyspread";
      genericName = "Spreadsheet";
      comment = "A Python-oriented spreadsheet application";
      categories = [ "Office" "Development" "Spreadsheet" ];
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
    maintainers = with lib.maintainers; [ AndersonTorres ];
  };
}
