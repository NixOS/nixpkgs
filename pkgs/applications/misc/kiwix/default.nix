{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  libkiwix,
  pkg-config,
  qmake,
  qtbase,
  qtwebengine,
  qtsvg,
  qtimageformats,
  wrapQtAppsHook,
  aria2,
}:

stdenv.mkDerivation rec {
  pname = "kiwix";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "kiwix";
    repo = "kiwix-desktop";
    rev = version;
    hash = "sha256-B3RcYr/b8pZTJV35BWuqmWbq+C2WkkcwBR0oNaUXPRw=";
  };

  patches = [
    ./remove-Werror.patch
  ];

  nativeBuildInputs = [
    qmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    libkiwix
    qtbase
    qtwebengine
    qtsvg
    qtimageformats
  ];

  qtWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ aria2 ]}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Offline reader for Web content";
    mainProgram = "kiwix-desktop";
    homepage = "https://kiwix.org";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ greg ];
  };
}
