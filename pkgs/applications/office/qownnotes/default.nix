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
<<<<<<< HEAD
, botan2
, pkg-config
, nixosTests
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

let
  pname = "qownnotes";
  appname = "QOwnNotes";
<<<<<<< HEAD
  version = "23.8.1";
=======
  version = "23.5.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in
stdenv.mkDerivation {
  inherit pname appname version;

  src = fetchurl {
<<<<<<< HEAD
    url = "https://github.com/pbek/QOwnNotes/releases/download/v${version}/qownnotes-${version}.tar.xz";
    hash = "sha256-ZS9OzC+pdtYY4xLQ3G31/Sw/xx4qgDjp+nAcPJdl0tk=";
=======
    url = "https://download.tuxfamily.org/${pname}/src/${pname}-${version}.tar.xz";
    hash = "sha256-W1bu3isEe1j7XTj+deLNk6Ncssy2UKG+eF36fe1FFWs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    qmake
    qttools
    wrapQtAppsHook
<<<<<<< HEAD
    pkg-config
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ] ++ lib.optionals stdenv.isDarwin [ makeWrapper ];

  buildInputs = [
    qtbase
    qtdeclarative
    qtsvg
    qtwebsockets
    qt5compat
<<<<<<< HEAD
    botan2
  ] ++ lib.optionals stdenv.isLinux [ qtwayland ];

  qmakeFlags = [
    "USE_SYSTEM_BOTAN=1"
  ];

=======
  ] ++ lib.optionals stdenv.isLinux [ qtwayland ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  # Tests QOwnNotes using the NixOS module by launching xterm:
  passthru.tests.basic-nixos-module-functionality = nixosTests.qownnotes;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
