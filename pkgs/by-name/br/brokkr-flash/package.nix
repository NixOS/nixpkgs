{
  lib,
  stdenv,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
  cmake,
  fmt_11,
  qt6,
  spdlog,
  icoutils,
  debug ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "brokkr-flash";
  version = "2.4.8";

  src = fetchFromGitHub {
    owner = "Gabriel2392";
    repo = "brokkr-flash";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Tz/PFreOvxBSfTeMnVyK4dLKr9A7BcnddoBqlSSNwcY=";
  };

  patches = [
    ./fix-cmake-install.patch
  ];

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    icoutils
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
  ];

  cmakeBuildType = if debug then "Debug" else "Release";

  cmakeFlags = [
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_SPDLOG" "${spdlog.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_FMT" "${fmt_11.src}")
  ];

  postInstall = ''
    mkdir -p $out/share/icons/hicolor/256x256/apps
    icotool -x $src/assets/brokkr.ico
    mv brokkr_1_256x256x32.png $out/share/icons/hicolor/256x256/apps/brokkr.png
    rm -rf $out/lib $out/include
  '';

  desktopItems = [
    (makeDesktopItem {
      type = "Application";
      name = "brokkr";
      desktopName = "Brokkr";
      comment = "Samsung device flashing utility";
      exec = "brokkr";
      terminal = false;
      icon = "brokkr";
      categories = [ "Utility" ];
      keywords = [
        "samsung"
        "odin"
        "heimdall"
        "flash"
      ];
    })
  ];

  strictDeps = true;

  __structuredAttrs = true;

  meta = {
    description = "Samsung device flashing utility";
    homepage = "https://github.com/Gabriel2392/brokkr-flash";
    changelog = "https://github.com/Gabriel2392/brokkr-flash/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ungeskriptet ];
    mainProgram = "brokkr";
  };
})
