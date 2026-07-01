{
  atracdenc,
  bash,
  cmake,
  copyDesktopItems,
  fetchFromGitHub,
  ffmpeg,
  lib,
  libcdio,
  libcdio-paranoia,
  libgcrypt,
  libgpg-error,
  libusb1,
  makeDesktopItem,
  netmdplusplus,
  nlohmann_json,
  pkg-config,
  qt5,
  stdenv,
  taglib,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "cd2netmd-gui";
  version = "2.1.4";

  src = fetchFromGitHub {
    owner = "Jo2003";
    repo = "cd2netmd_gui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WPcs96xA3FGo62pIKC+xwqm4s3Gxo0l9HMx8vmH+9xg=";
  };

  buildInputs = [
    libcdio
    libcdio-paranoia
    libgcrypt
    libgpg-error
    libusb1
    netmdplusplus
    nlohmann_json
    qt5.qtbase
    taglib
  ];

  cmakeFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "-DQ_OS_MAC=1"
  ];

  postPatch = ''
    # Source uses git tags to determine version. We replace that here to avoid
    # a build dependency on the .git directory
    echo "#define GIT_VERSION \"v${finalAttrs.version}\"" > git_version.h
    substituteInPlace CMakeLists.txt \
      --replace-fail \
        'add_custom_target(git_version_h COMMAND cd ${"$"}{CMAKE_SOURCE_DIR} && ./upd_git_version.sh)' \
        "" \
      --replace-fail \
        'add_dependencies(netmd_wizard git_version_h)' \
        ""

    # Fix CLI invocation of atracdenc to use absolute path
    substituteInPlace cxenc.h \
      --replace-fail \
        'static constexpr const char* XENC_CLI = "toolchain/atracdenc.exe";' \
        'static constexpr const char* XENC_CLI = "${lib.getExe atracdenc}";' \
      --replace-fail \
        'static constexpr const char* XENC_CLI = "atracdenc";' \
        'static constexpr const char* XENC_CLI = "${lib.getExe atracdenc}";'

    # Fix CLI invocation of ffmpeg to use absolute path
    substituteInPlace cffmpeg.h \
      --replace-fail \
        'static constexpr const char* FFMPEG_CLI = "toolchain/ffmpeg.exe";' \
        'static constexpr const char* FFMPEG_CLI = "${lib.getExe ffmpeg}";' \
      --replace-fail \
        'static constexpr const char* FFMPEG_CLI = "ffmpeg";' \
        'static constexpr const char* FFMPEG_CLI = "${lib.getExe ffmpeg}";' \
      --replace-fail \
        'static constexpr const char* FFMPEG_CLI = "c2nffmpeg";' \
        'static constexpr const char* FFMPEG_CLI = "${lib.getExe ffmpeg}";'
    substituteInPlace cffmpeg.cpp \
      --replace-fail \
        'QString encTool = QString("%1/%2").arg(sAppDir).arg(FFMPEG_CLI);' \
        'QString encTool = FFMPEG_CLI;' \
      --replace-fail \
        'QString ffmpeg = QFile::exists(QString("/usr/bin/%1").arg(FFMPEG_CLI)) ? FFMPEG_CLI : "ffmpeg";' \
        'QString ffmpeg = FFMPEG_CLI;'

    # Let cmake handle the install phase
    echo "install(TARGETS netmd_wizard)" >> CMakeLists.txt
  '';

  postInstall = ''
    # Install application icon
    mkdir -p $out/share/icons/hicolor/256x256/apps
    install -Dm 444 ${finalAttrs.src}/res/netmd_wizard.png $out/share/icons/hicolor/256x256/apps/
  '';

  nativeBuildInputs = [
    cmake
    copyDesktopItems
    pkg-config
    qt5.wrapQtAppsHook
  ];

  propagatedBuildInputs = [
    atracdenc
    ffmpeg
  ];

  desktopItems = [
    (makeDesktopItem {
      name = "NetMD Wizard";
      genericName = "NetMD MiniDisc burner";
      desktopName = "NetMD Wizard";
      exec = "netmd_wizard";
      icon = "netmd_wizard";
      comment = "Transfer audio from CD to NetMD";
      keywords = [
        "audio"
        "minidisc"
        "netmd"
      ];
      categories = [
        "Audio"
        "AudioVideo"
        "DiscBurning"
        "Qt"
      ];
      terminal = false;
    })
  ];

  meta = {
    description = "Transfer audio from CD to NetMD";
    license = lib.licenses.gpl3Plus;
    homepage = "https://github.com/Jo2003/cd2netmd_gui";
    changelog = "https://github.com/Jo2003/cd2netmd_gui/releases/tag/v${finalAttrs.version}";
    maintainers = with lib.maintainers; [ ddelabru ];
    mainProgram = "netmd_wizard";
    platforms = lib.platforms.all;
  };
})
