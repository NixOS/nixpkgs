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
, botan2
, pkg-config
, nixosTests
}:

let
  pname = "qownnotes";
  appname = "QOwnNotes";
  version = "24.3.5";
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchurl {
    url = "https://github.com/pbek/QOwnNotes/releases/download/v${version}/qownnotes-${version}.tar.xz";
    hash = "sha256-s3OeTK6XodIMrNTuImdljbQYX1Abj7SFOZmPJgm2teo=";
  };

  nativeBuildInputs = [
    qmake
    qttools
    wrapQtAppsHook
    pkg-config
  ] ++ lib.optionals stdenv.isDarwin [ makeWrapper ];

  buildInputs = [
    qtbase
    qtdeclarative
    qtsvg
    qtwebsockets
    qt5compat
    botan2
  ] ++ lib.optionals stdenv.isLinux [ qtwayland ];

  qmakeFlags = [
    "USE_SYSTEM_BOTAN=1"
  ];

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

  # Tests QOwnNotes using the NixOS module by launching xterm:
  passthru.tests.basic-nixos-module-functionality = nixosTests.qownnotes;

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
