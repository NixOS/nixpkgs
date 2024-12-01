{
  lib,
  stdenv,
  fetchFromGitHub,
  qmake,
  pkg-config,
  wrapQtAppsHook,
  qtbase,
  qttools,
  qtwebkit,
  sqlite,
}:

stdenv.mkDerivation rec {
  pname = "quiterss";
  version = "0.19.4";

  src = fetchFromGitHub {
    owner = "QuiteRSS";
    repo = "quiterss";
    rev = version;
    sha256 = "1cgvl67vhn5y7bj5gbjbgk26bhb0196bgrgsp3r5fmrislarj8s6";
  };

  nativeBuildInputs = [
    qmake
    pkg-config
    wrapQtAppsHook
  ];
  buildInputs = [
    qtbase
    qttools
    qtwebkit
    sqlite.dev
  ];

  meta = with lib; {
    description = "Qt-based RSS/Atom news feed reader";
    longDescription = ''
      QuiteRSS is a open-source cross-platform RSS/Atom news feeds reader
      written on Qt/C++
    '';
    homepage = "https://quiterss.org";
    changelog = "https://github.com/QuiteRSS/quiterss/blob/${version}/CHANGELOG";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ primeos ];
  };
}
