{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libsForQt5,
  scrcpy,
  android-tools,
  ffmpeg,
  makeDesktopItem,
  copyDesktopItems,
}:

stdenv.mkDerivation rec {
  pname = "qtscrcpy";
  version = "3.0.0";

  src =
    (fetchFromGitHub {
      owner = "barry-ran";
      repo = "QtScrcpy";
      rev = "refs/tags/v${version}";
      hash = "sha256-RW+7aHcxFEO4H9SVKfAfuwY0IXwThxM29oVS5zhWbpY=";
      fetchSubmodules = true;
    }).overrideAttrs
      (_: {
        GIT_CONFIG_COUNT = 1;
        GIT_CONFIG_KEY_0 = "url.https://github.com/.insteadOf";
        GIT_CONFIG_VALUE_0 = "git@github.com:";
      });

  patches = [
    # remove vendored ffmpeg, adb and scrcpy-server
    ./remove_vendors.patch

    # remove predefined adb and scrcpy-server path
    # we later set them in wrapper
    ./remove_predefined_paths.patch

    # remove avcodec_close which is deprecated in ffmpeg_7
    # This doesn't affect functionality because
    # it's followed by avcodec_free_context
    ./remove_deprecated_avcodec_free_context.patch
  ];

  postPatch = ''
    substituteInPlace QtScrcpy/QtScrcpyCore/{include/QtScrcpyCoreDef.h,src/device/server/server.h} \
      --replace-fail 'serverVersion = "2.1.1"' 'serverVersion = "${scrcpy.version}"'
    substituteInPlace QtScrcpy/util/config.cpp \
      --replace-fail 'COMMON_SERVER_VERSION_DEF "2.1.1"' 'COMMON_SERVER_VERSION_DEF "${scrcpy.version}"'
    substituteInPlace QtScrcpy/audio/audiooutput.cpp \
      --replace-fail 'sndcpy.sh' "$out/share/qtscrcpy/sndcpy.sh"
    substituteInPlace QtScrcpy/sndcpy/sndcpy.sh \
      --replace-fail 'ADB=./adb' "ADB=${lib.getExe' android-tools "adb"}" \
      --replace-fail 'SNDCPY_APK=sndcpy.apk' "SNDCPY_APK=$out/share/qtscrcpy/sndcpy.apk"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.wrapQtAppsHook
    copyDesktopItems
  ];

  buildInputs =
    [
      scrcpy
      # Upstream vendors ffmpeg_4
      ffmpeg
    ]
    ++ (with libsForQt5; [
      qtbase
      qtmultimedia
      qtx11extras
    ]);

  env.NIX_CFLAGS_COMPILE = toString [
    "-Wno-error=sign-compare"
  ];

  # Doesn't contain rule to install
  installPhase = ''
    runHook preInstall

    pushd ../output/x64/Release
      install -Dm755 QtScrcpy -t $out/bin
      install -Dm755 sndcpy.sh -t $out/share/qtscrcpy
      install -Dm644 sndcpy.apk -t $out/share/qtscrcpy
    popd

    install -Dm644 ../QtScrcpy/res/image/tray/logo.png $out/share/pixmaps/qtscrcpy.png

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "QtScrcpy";
      exec = "QtScrcpy %U";
      icon = "qtscrcpy";
      desktopName = "QtScrcpy";
      genericName = "Android Display Control";
      categories = [
        "Utility"
        "RemoteAccess"
      ];
    })
  ];

  preFixup = ''
    qtWrapperArgs+=(
      --set QTSCRCPY_ADB_PATH ${lib.getExe' android-tools "adb"}
      --set QTSCRCPY_SERVER_PATH ${scrcpy}/share/scrcpy/scrcpy-server
    )
  '';

  meta = {
    description = "Android real-time display control software";
    homepage = "https://github.com/barry-ran/QtScrcpy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      daru-san
      aleksana
    ];
    mainProgram = "QtScrcpy";
    platforms = with lib.platforms; linux ++ darwin ++ windows;
    # needs some special handling on darwin as it generates .app bundle directly
    badPlatforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      # Still includes sndcpy.apk vendored in the same repo
      # which will run on controlled Android device
      # https://github.com/barry-ran/QtScrcpy/blob/master/QtScrcpy/sndcpy/sndcpy.apk
      binaryBytecode
    ];
  };
}
