{
  lib,
  stdenv,
  copyDesktopItems,
  makeDesktopItem,
  fetchFromGitLab,
  qmake,
  wrapQtAppsHook,
  # qt
  qtbase,
  qtwebsockets,
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
    copyDesktopItems
    qmake
    wrapQtAppsHook
  ];
  buildInputs = [
    qtbase
    qtwebsockets
  ];

  qmakeFlags = [
    "michabo.pro"
    "DESTDIR=${placeholder "out"}/bin"
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "Michabo";
      desktopName = "Michabo";
      exec = "Michabo";
    })
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
