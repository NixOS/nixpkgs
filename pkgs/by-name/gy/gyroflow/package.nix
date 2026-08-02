{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  makeDesktopItem,
  clang,
  copyDesktopItems,
  patchelf,
  pkg-config,
  qt6,
  alsa-lib,
  bash,
  bzip2,
  ffmpeg_7,
  libicns,
  libxml2,
  mdk-sdk,
  ocl-icd,
  opencv,
  zlib,
}:
let
  lens-profiles = fetchFromGitHub {
    owner = "gyroflow";
    repo = "lens_profiles";
    tag = "v36";
    hash = "sha256-JjH7cGT9hzB9pv0W6FUPaejkiUj357IM2siJNrSHiYY=";
  };
in
rustPlatform.buildRustPackage rec {
  pname = "gyroflow";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "gyroflow";
    repo = "gyroflow";
    tag = "v${version}";
    hash = "sha256-ncGbM8wIwnyLHp+oArgDnKCCGIeywdH7YGZPgRBLiJM=";
  };

  cargoHash = "sha256-9UamQxrKVMSivhZ/cvRRCliaf3eFeHg5XPPtuaRKrg0=";

  nativeBuildInputs = [
    clang
    pkg-config
    rustPlatform.bindgenHook
    qt6.wrapQtAppsHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    copyDesktopItems
    patchelf
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    libicns
  ];

  buildInputs = [
    bash
    ffmpeg_7
    mdk-sdk
    opencv
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    ocl-icd
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    bzip2
    libxml2
    zlib
  ];

  postPatch = ''
    substituteInPlace build.rs \
      --replace-fail 'println!("cargo:rustc-link-lib=static:+whole-archive=z")' ""
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace build.rs \
      --replace-fail 'println!("cargo:rustc-link-lib=static:+whole-archive=x264");' "" \
      --replace-fail 'println!("cargo:rustc-link-lib=static=x265");' ""
  '';

  # qml-video-rs and gyroflow assume that all Qt headers are installed
  # in a single (qtbase) directory.  Apart form QtCore and QtGui from
  # qtbase they need QtQuick and QtQml public and private headers from
  # qtdeclarative:
  # https://github.com/AdrianEddy/qml-video-rs/blob/bbf60090b966f0df2dd016e01da2ea78666ecea2/build.rs#L22-L40
  # https://github.com/gyroflow/gyroflow/blob/v1.5.4/build.rs#L163-L186
  # Additionally gyroflow needs QtQuickControls2:
  # https://github.com/gyroflow/gyroflow/blob/v1.5.4/build.rs#L173
  env.NIX_CFLAGS_COMPILE = toString (
    if stdenv.hostPlatform.isDarwin then
      [
        "-F${qt6.qtdeclarative}/lib"
        "-I${qt6.qtdeclarative}/lib/QtQuick.framework/Headers"
        "-I${qt6.qtdeclarative}/lib/QtQuick.framework/Headers/${qt6.qtdeclarative.version}"
        "-I${qt6.qtdeclarative}/lib/QtQuick.framework/Headers/${qt6.qtdeclarative.version}/QtQuick"
        "-I${qt6.qtdeclarative}/lib/QtQml.framework/Headers"
        "-I${qt6.qtdeclarative}/lib/QtQml.framework/Headers/${qt6.qtdeclarative.version}"
        "-I${qt6.qtdeclarative}/lib/QtQml.framework/Headers/${qt6.qtdeclarative.version}/QtQml"
        "-I${qt6.qtdeclarative}/lib/QtQuickControls2.framework/Headers"
      ]
    else
      [
        "-I${qt6.qtdeclarative}/include/QtQuick"
        "-I${qt6.qtdeclarative}/include/QtQuick/${qt6.qtdeclarative.version}"
        "-I${qt6.qtdeclarative}/include/QtQuick/${qt6.qtdeclarative.version}/QtQuick"
        "-I${qt6.qtdeclarative}/include/QtQml"
        "-I${qt6.qtdeclarative}/include/QtQml/${qt6.qtdeclarative.version}"
        "-I${qt6.qtdeclarative}/include/QtQml/${qt6.qtdeclarative.version}/QtQml"
        "-I${qt6.qtdeclarative}/include/QtQuickControls2"
      ]
  );

  # FFMPEG_DIR is used by ffmpeg-sys-next/build.rs and
  # gyroflow/build.rs.  ffmpeg-sys-next fails to build if this dir
  # does not contain ffmpeg *headers*.  gyroflow assumes that it
  # contains ffmpeg *libraries*, but builds fine as long as it is set
  # with any value.
  env.FFMPEG_DIR = ffmpeg_7.dev;

  # These variables are needed by gyroflow/build.rs.
  # OPENCV_LINK_LIBS is based on the value in gyroflow/_scripts/common.just, with opencv_dnn added to fix linking.
  env.OPENCV_LINK_PATHS = "${opencv}/lib";
  env.OPENCV_LINK_LIBS = "opencv_core,opencv_calib3d,opencv_dnn,opencv_features2d,opencv_imgproc,opencv_video,opencv_flann,opencv_imgcodecs,opencv_objdetect,opencv_stitching,png";

  # For qml-video-rs. It concatenates "lib/" to this value so it needs a trailing "/":
  env.MDK_SDK = "${mdk-sdk}/";

  preCheck = ''
    # qml-video-rs/build.rs wants to overwrite it:
    find target -name libmdk.so.0 -exec chmod +w {} \;
  '';

  doCheck = false; # No tests.

  # mdk-sdk license key is hardcoded to 'gyroflow' process name, wrapQt changes it,
  # which breaks the license check and throws a QR code
  dontWrapQtApps = true;

  postInstall =
    if stdenv.hostPlatform.isDarwin then
      ''
        contents=$out/Applications/Gyroflow.app/Contents

        mkdir -p $out/Applications
        cp -r _deployment/mac/Gyroflow.app $out/Applications/
        find $out/Applications/Gyroflow.app -name .empty -delete

        # Qt is located through wrapQtAppsHook, so drop upstream's qt.conf,
        # which points plugin and QML lookups back inside the bundle.
        rm $contents/Resources/qt.conf

        substituteInPlace $contents/Info.plist \
          --replace-fail \
            '<key>CFBundleExecutable</key>                  <string>gyroflow</string>' \
            '<key>CFBundleExecutable</key>                  <string>gyroflow-launcher</string>'

        png2icns $contents/Resources/AppIcon.icns resources/icon_1024_mac.png

        ln -s ${lens-profiles} $contents/Resources/camera_presets

        install_name_tool -add_rpath ${mdk-sdk}/lib $out/bin/gyroflow
        mv $out/bin/gyroflow $contents/MacOS/gyroflow
        rmdir $out/bin

        rm -rf $out/lib
      ''
    else
      ''
        mkdir -p $out/opt/Gyroflow
        cp -r resources $out/opt/Gyroflow/
        ln -s ${lens-profiles} $out/opt/Gyroflow/resources/camera_presets

        rm -rf $out/lib
        patchelf $out/bin/gyroflow --add-rpath ${mdk-sdk}/lib

        mv $out/bin/gyroflow $out/opt/Gyroflow/

        install -D ${./gyroflow-open.sh} $out/bin/gyroflow-open
        install -Dm644 ${./gyroflow-mime.xml} $out/share/mime/packages/gyroflow.xml
        install -Dm644 resources/icon.svg $out/share/icons/hicolor/scalable/apps/gyroflow.svg
      '';

  postFixup =
    if stdenv.hostPlatform.isDarwin then
      ''
        macos=$out/Applications/Gyroflow.app/Contents/MacOS
        makeQtWrapper $macos/gyroflow $macos/gyroflow-launcher

        mkdir -p $out/bin
        ln -s ../Applications/Gyroflow.app/Contents/MacOS/gyroflow-launcher $out/bin/gyroflow
      ''
    else
      ''
        makeQtWrapper $out/opt/Gyroflow/gyroflow $out/bin/gyroflow
      '';

  desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
    (makeDesktopItem {
      name = "gyroflow";
      desktopName = "Gyroflow";
      genericName = "Video stabilization using gyroscope data";
      comment = meta.description;
      icon = "gyroflow";
      exec = "gyroflow-open %u";
      terminal = false;
      mimeTypes = [ "application/x-gyroflow" ];
      categories = [
        "AudioVideo"
        "Video"
        "AudioVideoEditing"
        "Qt"
      ];
      startupNotify = true;
      startupWMClass = "gyroflow";
      prefersNonDefaultGPU = true;
    })
  ];

  meta = {
    description = "Advanced gyro-based video stabilization tool";
    homepage = "https://gyroflow.xyz";
    license = with lib.licenses; [
      gpl3Plus
      cc0
    ];
    maintainers = with lib.maintainers; [
      Br1ght0ne
      BatteredBunny
    ];
    platforms = [
      "aarch64-darwin"
      "x86_64-linux"
    ];
  };
}
