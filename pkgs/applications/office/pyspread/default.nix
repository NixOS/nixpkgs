{ lib
, copyDesktopItems
, makeDesktopItem
, python3
, qtsvg
, wrapQtAppsHook
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pyspread";
  version = "2.0.2";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    hash = "sha256-rg2T9Y9FU2a+aWg0XM8jyQB9t8zDVlpad3TjUcx4//8=";
  };

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

  doCheck = false; # it fails miserably with a core dump

  pythonImportsCheck = [ "pyspread" ];

  desktopItems = [
    (makeDesktopItem rec {
      name = pname;
      exec = name;
      icon = name;
      desktopName = "Pyspread";
      genericName = "Spreadsheet";
      comment = meta.description;
      categories = [ "Office" "Development" "Spreadsheet" ];
    })
  ];

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = with lib; {
    homepage = "https://pyspread.gitlab.io/";
    description = "A Python-oriented spreadsheet application";
    longDescription = ''
      pyspread is a non-traditional spreadsheet application that is based on and
      written in the programming language Python. The goal of pyspread is to be
      the most pythonic spreadsheet.

      pyspread expects Python expressions in its grid cells, which makes a
      spreadsheet specific language obsolete. Each cell returns a Python object
      that can be accessed from other cells. These objects can represent
      anything including lists or matrices.
    '';
    license = with licenses; gpl3Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; all;
  };
}
