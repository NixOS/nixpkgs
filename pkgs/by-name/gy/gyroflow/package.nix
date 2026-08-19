{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchurl,
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
  nix-update-script,
  ocl-icd,
  opencv,
  versionCheckHook,
  zlib,
}:
let
  lens-profiles-version = "v41";

  lens-profiles-db = fetchurl {
    url = "https://github.com/gyroflow/lens_profiles/releases/download/${lens-profiles-version}/profiles.cbor.gz";
    hash = "sha256-W5E2aXt13fnNogll8X54a2yFMOPVkQn4dQUGlgLn9nY=";
  };
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gyroflow";
  version = "1.6.3";

  src = fetchFromGitHub {
    owner = "gyroflow";
    repo = "gyroflow";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ncGbM8wIwnyLHp+oArgDnKCCGIeywdH7YGZPgRBLiJM=";
  };

  cargoHash = "sha256-9UamQxrKVMSivhZ/cvRRCliaf3eFeHg5XPPtuaRKrg0=";

  __structuredAttrs = true;
  strictDeps = true;

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
    install -Dm644 ${lens-profiles-db} resources/camera_presets/profiles.cbor.gz

    substituteInPlace build.rs \
      --replace-fail 'println!("cargo:rustc-link-lib=static:+whole-archive=z")' ""

    # Breaks reproducibility with build time embedded in the binary
    substituteInPlace build.rs \
      --replace-fail 'println!("cargo:rustc-env=BUILD_TIME={}", (time.as_secs() - 1642516578) / 600);' ""
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

  doCheck = false; # No tests.

  # mdk-sdk license key is hardcoded to 'gyroflow' process name, wrapQt changes it,
  # which breaks the license check and throws a QR code
  dontWrapQtApps = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;

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

        install -Dm644 ${lens-profiles-db} $contents/Resources/camera_presets/profiles.cbor.gz

        install_name_tool -add_rpath ${mdk-sdk}/lib $out/bin/gyroflow
        mv $out/bin/gyroflow $contents/MacOS/gyroflow
        rmdir $out/bin

        rm -rf $out/lib
      ''
    else
      ''
        mkdir -p $out/opt/Gyroflow
        cp -r resources $out/opt/Gyroflow/

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
      comment = finalAttrs.meta.description;
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Advanced gyro-based video stabilization tool";
    homepage = "https://gyroflow.xyz";
    mainProgram = "gyroflow";
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
})
