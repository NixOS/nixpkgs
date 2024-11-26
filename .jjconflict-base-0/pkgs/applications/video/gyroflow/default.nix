{
  lib,
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
  ffmpeg,
  mdk-sdk,
  ocl-icd,
  opencv,
}:
let
  lens-profiles = fetchFromGitHub {
    owner = "gyroflow";
    repo = "lens_profiles";
    tag = "v19";
    hash = "sha256-8R2mMqKxzoa5Sfqxs8pcfwUfo1PQKSrnM+60Ri3wiXY=";
  };
in
rustPlatform.buildRustPackage rec {
  pname = "gyroflow";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "gyroflow";
    repo = "gyroflow";
    tag = "v${version}";
    hash = "sha256-Ib9GnHN23eTbd3nEwvZf3+CBSkUHycN77o3ura0Ze/0=";
  };

  useFetchCargoVendor = true;

  cargoHash = "sha256-bqBFAobXwPC4V0OYHbwmkk7shfiFt3YMGAf7F5ybLAQ=";

  nativeBuildInputs = [
    clang
    copyDesktopItems
    patchelf
    pkg-config
    rustPlatform.bindgenHook
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    bash
    ffmpeg
    mdk-sdk
    ocl-icd
    opencv
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
  ];

  postPatch = ''
    substituteInPlace build.rs \
      --replace-fail 'println!("cargo:rustc-link-lib=static:+whole-archive=z")' ""
  '';

  # qml-video-rs and gyroflow assume that all Qt headers are installed
  # in a single (qtbase) directory.  Apart form QtCore and QtGui from
  # qtbase they need QtQuick and QtQml public and private headers from
  # qtdeclarative:
  # https://github.com/AdrianEddy/qml-video-rs/blob/bbf60090b966f0df2dd016e01da2ea78666ecea2/build.rs#L22-L40
  # https://github.com/gyroflow/gyroflow/blob/v1.5.4/build.rs#L163-L186
  # Additionally gyroflow needs QtQuickControls2:
  # https://github.com/gyroflow/gyroflow/blob/v1.5.4/build.rs#L173
  env.NIX_CFLAGS_COMPILE = toString [
    "-I${qt6.qtdeclarative}/include/QtQuick"
    "-I${qt6.qtdeclarative}/include/QtQuick/${qt6.qtdeclarative.version}"
    "-I${qt6.qtdeclarative}/include/QtQuick/${qt6.qtdeclarative.version}/QtQuick"
    "-I${qt6.qtdeclarative}/include/QtQml"
    "-I${qt6.qtdeclarative}/include/QtQml/${qt6.qtdeclarative.version}"
    "-I${qt6.qtdeclarative}/include/QtQml/${qt6.qtdeclarative.version}/QtQml"
    "-I${qt6.qtdeclarative}/include/QtQuickControls2"
  ];

  # FFMPEG_DIR is used by ffmpeg-sys-next/build.rs and
  # gyroflow/build.rs.  ffmpeg-sys-next fails to build if this dir
  # does not contain ffmpeg *headers*.  gyroflow assumes that it
  # contains ffmpeg *libraries*, but builds fine as long as it is set
  # with any value.
  env.FFMPEG_DIR = ffmpeg.dev;

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

  postInstall = ''
    mkdir -p $out/opt/Gyroflow
    cp -r resources $out/opt/Gyroflow/
    ln -s ${lens-profiles} $out/opt/Gyroflow/resources/camera_presets

    rm -rf $out/lib
    patchelf $out/bin/gyroflow --add-rpath ${mdk-sdk}/lib

    mv $out/bin/gyroflow $out/opt/Gyroflow/
    ln -s ../opt/Gyroflow/gyroflow $out/bin/

    install -D ${./gyroflow-open.sh} $out/bin/gyroflow-open
    install -Dm644 ${./gyroflow-mime.xml} $out/share/mime/packages/gyroflow.xml
    install -Dm644 resources/icon.svg $out/share/icons/hicolor/scalable/apps/gyroflow.svg
  '';

  desktopItems = [
    (makeDesktopItem ({
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
    }))
  ];

  meta = {
    description = "Advanced gyro-based video stabilization tool";
    homepage = "https://gyroflow.xyz";
    license = with lib.licenses; [
      gpl3Plus
      cc0
    ];
    maintainers = with lib.maintainers; [ orivej ];
    platforms = [ "x86_64-linux" ];
  };
}
