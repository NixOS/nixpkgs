{
  lib,
  stdenv,
  fetchFromGitHub,
  copyDesktopItems,
  makeDesktopItem,
  cmake,
  qt6,
  icoutils,
  debug ? false,
}:
let
  spdlogSrc = fetchFromGitHub {
    owner = "gabime";
    repo = "spdlog";
    tag = "v1.17.0";
    hash = "sha256-bL3hQmERXNwGmDoi7+wLv/TkppGhG6cO47k1iZvJGzY=";
  };
  fmtSrc = fetchFromGitHub {
    owner = "fmtlib";
    repo = "fmt";
    tag = "12.1.0";
    hash = "sha256-ZmI1Dv0ZabPlxa02OpERI47jp7zFfjpeWCy1WyuPYZ0=";
  };
in
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
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_SPDLOG" spdlogSrc.outPath)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_FMT" fmtSrc.outPath)
  ];

  postInstall = ''
    mkdir -p $out/share/icons/hicolor/256x256/apps
    icotool -x $src/assets/brokkr.ico
    mv brokkr_1_256x256x32.png $out/share/icons/hicolor/256x256/apps/brokkr.png
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
