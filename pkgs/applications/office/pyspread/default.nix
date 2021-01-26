{ lib
, buildPythonApplication
, fetchPypi
, makeDesktopItem
, makePythonPath
, dateutil
, matplotlib
, numpy
, pyenchant
, pyqt5
, pytest
, python
, qtsvg
, runtimeShell
, wrapQtAppsHook
}:

buildPythonApplication rec {
  pname = "pyspread";
  version = "1.99.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-05bC+Uvx72FAh3qxkgXm8jdb/gHRv1D/M7tjOEdE3Xg=";
  };

  pythonLibs = [
    dateutil
    matplotlib
    numpy
    pyenchant
    pyqt5
  ];

  nativeBuildInputs = [ wrapQtAppsHook ];
  buildInputs = pythonLibs ++ [
    qtsvg
  ];

  doCheck = false; # it fails miserably with a core dump

  desktopItem = makeDesktopItem rec {
    name = pname;
    exec = name;
    icon = name;
    desktopName = "Pyspread";
    genericName = "Spreadsheet";
    comment = meta.description;
    categories = "Office;Development;Spreadsheet;";
  };

  postInstall = ''
    runHook preInstall
    install -D $out/share/applications
    install -m 644 $desktopItem/share/applications/* $out/share/applications
    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup
    sed -i -e "s|#!/bin/bash|#!${runtimeShell}|" $out/bin/pyspread
    wrapProgram $out/bin/pyspread \
      --prefix PYTHONPATH ':' $(toPythonPath $out):${makePythonPath pythonLibs} \
      --prefix PATH ':' ${python}/bin/ \
      ''${qtWrapperArgs[@]}
    runHook postFixup
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
