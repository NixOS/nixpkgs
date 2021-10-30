{ lib
, python3
, fetchpatch
, makeDesktopItem
, qtsvg
, wrapQtAppsHook
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pyspread";
  version = "1.99.6";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-B1oyWUAXn63mmVFN9brJwbHxi7I5nYrK2JJU1DjAlb8=";
  };

  patches = [
    # https://gitlab.com/pyspread/pyspread/-/merge_requests/34
    (fetchpatch {
      name = "entry-points.patch";
      url = "https://gitlab.com/pyspread/pyspread/-/commit/3d8da6a7a7d76f7027d77ca95fac103961d729a2.patch";
      excludes = [ "bin/pyspread" "bin/pyspread.bat" ];
      sha256 = "1l614k7agv339hrin23jj7s1mq576vkdfkdim6wp224k7y37bnil";
    })
  ];

  nativeBuildInputs = [
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
    install -m 444 -Dt $out/share/applications ${desktopItem}/share/applications/*
  '';

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
