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
, qtx11extras
, qtxmlpatterns
, makeWrapper
, wrapQtAppsHook
}:

let
  pname = "qownnotes";
  appname = "QOwnNotes";
  version = "23.1.1";
in
stdenv.mkDerivation {
  inherit pname appname version;

  src = fetchurl {
    url = "https://download.tuxfamily.org/${pname}/src/${pname}-${version}.tar.xz";
    sha256 = "sha256-BMisfFMy3kNoZHCYbGqzT9hxzVpKBUN6fSOilPw9O1w=";
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
    qtx11extras
    qtxmlpatterns
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
    maintainers = with maintainers; [ totoroot ];
    platforms = platforms.unix;
  };
}
