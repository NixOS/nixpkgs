{ lib
, stdenv
, fetchurl
, qmake
, qttools
, qtbase
, qtdeclarative
, qtsvg
, qtwayland
, qtwebsockets
, qt5compat
, makeWrapper
, wrapQtAppsHook
}:

let
  pname = "qownnotes";
  appname = "QOwnNotes";
  version = "23.5.3";
in
stdenv.mkDerivation {
  inherit pname appname version;

  src = fetchurl {
    url = "https://download.tuxfamily.org/${pname}/src/${pname}-${version}.tar.xz";
    hash = "sha256-keNR+RMFVlHMeyT1Ngtuu2jWMDwFyLbZAVUk7c0Ed38=";
  };

  nativeBuildInputs = [
    qmake
    qttools
    wrapQtAppsHook
  ] ++ lib.optionals stdenv.isDarwin [ makeWrapper ];

  buildInputs = [
    qtbase
    qtdeclarative
    qtsvg
    qtwebsockets
    qt5compat
  ] ++ lib.optionals stdenv.isLinux [ qtwayland ];

  postInstall =
  # Create a lowercase symlink for Linux
  lib.optionalString stdenv.isLinux ''
    ln -s $out/bin/${appname} $out/bin/${pname}
  ''
  # Wrap application for macOS as lowercase binary
  + lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv $out/bin/${appname}.app $out/Applications
    makeWrapper $out/Applications/${appname}.app/Contents/MacOS/${appname} $out/bin/${pname}
  '';

  meta = with lib; {
    description = "Plain-text file notepad and todo-list manager with markdown support and Nextcloud/ownCloud integration";
    homepage = "https://www.qownnotes.org/";
    changelog = "https://www.qownnotes.org/changelog.html";
    downloadPage = "https://github.com/pbek/QOwnNotes/releases/tag/v${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ pbek totoroot ];
    platforms = platforms.unix;
  };
}
