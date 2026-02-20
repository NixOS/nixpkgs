{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  libkiwix,
  pkg-config,
  qt6,
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
    qt6.qmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    libkiwix
    qt6.qtbase
    qt6.qtwebengine
    qt6.qtsvg
    qt6.qtimageformats
  ];

  qtWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ aria2 ]}"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Offline reader for Web content";
    mainProgram = "kiwix-desktop";
    homepage = "https://kiwix.org";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ greg ];
  };
}
