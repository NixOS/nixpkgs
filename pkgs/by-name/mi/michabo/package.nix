{
  lib,
  stdenv,
  makeDesktopItem,
  fetchFromGitLab,
  libsForQt5,
  copyDesktopItems,
}:

stdenv.mkDerivation rec {
  pname = "michabo";
  version = "0.1";

  src = fetchFromGitLab {
    domain = "git.pleroma.social";
    owner = "kaniini";
    repo = "michabo";
    rev = "v${version}";
    sha256 = "0pl4ymdb36r0kwlclfjjp6b1qml3fm9ql7ag5inprny5y8vcjpzn";
  };

  nativeBuildInputs = [
    libsForQt5.qmake
    libsForQt5.wrapQtAppsHook
    copyDesktopItems
  ];
  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtwebsockets
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "Michabo";
      desktopName = "Michabo";
      exec = "Michabo";
    })
  ];

  qmakeFlags = [
    "michabo.pro"
    "DESTDIR=${placeholder "out"}/bin"
  ];

  meta = {
    description = "Native desktop app for Pleroma and Mastodon servers";
    mainProgram = "Michabo";
    homepage = "https://git.pleroma.social/kaniini/michabo";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ fgaz ];
    platforms = lib.platforms.all;
  };
}
