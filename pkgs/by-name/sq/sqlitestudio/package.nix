{
  stdenv,
  lib,
  fetchFromGitHub,
  libsForQt5,
  readline,
  tcl,
  python3,
  copyDesktopItems,
  makeDesktopItem,
}:
stdenv.mkDerivation rec {
  pname = "sqlitestudio";
  version = "3.4.6";

  src = fetchFromGitHub {
    owner = "pawelsalawa";
    repo = "sqlitestudio";
    rev = version;
    hash = "sha256-ETahZYAbayQEo+1mlSlJkUgzskIgdDdDM/MMOL2kXMk=";
  };

  nativeBuildInputs =
    [ copyDesktopItems ]
    ++ (with libsForQt5.qt5; [
      qmake
      qttools
      wrapQtAppsHook
    ]);

  buildInputs =
    [
      readline
      tcl
      python3
    ]
    ++ (with libsForQt5.qt5; [
      qtbase
      qtsvg
      qtdeclarative
      qtscript
    ]);

  qmakeFlags = [ "./SQLiteStudio3" ];

  desktopItems = [
    (makeDesktopItem {
      name = "sqlitestudio";
      desktopName = "SQLiteStudio";
      exec = "sqlitestudio";
      icon = "sqlitestudio";
      comment = "Database manager for SQLite";
      terminal = false;
      startupNotify = false;
      categories = [ "Development" ];
    })
  ];

  postInstall = ''
    install -Dm755 \
      ./SQLiteStudio3/guiSQLiteStudio/img/sqlitestudio.svg \
      $out/share/pixmaps/sqlitestudio.svg
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Free, open source, multi-platform SQLite database manager";
    homepage = "https://sqlitestudio.pl/";
    license = lib.licenses.gpl3;
    mainProgram = "sqlitestudio";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ asterismono ];
  };
}
