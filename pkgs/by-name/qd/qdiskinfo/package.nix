{
  lib,
  stdenv,
  smartmontools,
  fetchFromGitHub,
  cmake,
  qt6,
  makeDesktopItem,
  copyDesktopItems,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qdiskinfo";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "edisionnano";
    repo = "QDiskInfo";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-0zF3Nc5K8+K68HOSy30ieYvYP9/oSkTe0+cp0hVo9Gs=";
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
    copyDesktopItems
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtwayland
    smartmontools
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE:STRING=MinSizeRel"
    "-DQT_VERSION_MAJOR=6"
  ];

  postInstall = ''
    install -Dm644 $src/dist/QDiskInfo.svg $out/share/icons/hicolor/scalable/apps/QDiskInfo.svg

    wrapProgram $out/bin/QDiskInfo \
      --suffix PATH : ${smartmontools}/bin
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "QDiskInfo";
      exec = "QDiskInfo";
      icon = "QDiskInfo";
      comment = finalAttrs.meta.description;
      desktopName = "QDiskInfo";
      categories = [ "Utility" ];
    })
  ];

  meta = {
    description = "CrystalDiskInfo alternative for Linux";
    homepage = "https://github.com/edisionnano/QDiskInfo";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ roydubnium ];
    platforms = lib.platforms.linux;
    mainProgram = "QDiskInfo";
  };
})
