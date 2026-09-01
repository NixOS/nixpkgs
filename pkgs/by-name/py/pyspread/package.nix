{
  lib,
  python3Packages,
  fetchFromGitLab,
  qt6,
  R,
  copyDesktopItems,
  makeDesktopItem,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pyspread";
  version = "2.4.5";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitLab {
    owner = "pyspread";
    repo = "pyspread";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3DAoRIzwFxOEIXSCO+MyCAZ92Y57AD9Z9oq6ps1Ck0k=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  nativeBuildInputs = [
    R
    copyDesktopItems
    qt6.wrapQtAppsHook
  ];

  buildInputs = [ qt6.qtsvg ];

  dependencies = with python3Packages; [
    pyqt6
    numpy
    markdown2

    # Optional
    matplotlib # data visualization
    pyenchant # spellchecker bindings
    pip # python package installer
    python-dateutil # extensions to standard datetime module
    rpy2 # interface to R
    plotnine # data visualization
    openpyxl # r/w Excel 2010 xlsx/xlsm files

    # Optional & not in nixpkgs
    #py-moneyed # currency & money classes
    #pycel # compile Excel spreadsheets to Python code
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

  makeWrapperArgs = [
    "--set"
    "R_HOME"
    "${lib.getLib R}/lib/R"
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
    license = lib.licenses.gpl3Plus;
    mainProgram = "pyspread";
    maintainers = with lib.maintainers; [ Merikei ];
    platforms = lib.platforms.linux;
  };
})
