{
  lib,
  rustPlatform,
  fetchFromGitHub,
  callPackage,
  makeDesktopItem,
  clang,
  copyDesktopItems,
  patchelf,
  pkg-config,
  wrapQtAppsHook,
  alsa-lib,
  bash,
  ffmpeg,
  mdk-sdk,
  ocl-icd,
  opencv,
  qtbase,
  qtdeclarative,
  qtsvg,
}:

rustPlatform.buildRustPackage rec {
  pname = "gyroflow";
  version = "1.5.4-2023-12-25";

  src = fetchFromGitHub {
    owner = "gyroflow";
    repo = "gyroflow";
    rev = "e0869ffe648cb3fd88d81c807b1f7fa2e18d7430";
    hash = "sha256-KB/uoQR43im/m5uJhheAPCqUH9oIx85JaIUwW9rhAAw=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ahrs-0.6.0" = "sha256-CxWyX8t+BjqIyNj1p1LdkCmNrtJkudmKgZPv0MVcghY=";
      "akaze-0.7.0" = "sha256-KkGXKoVRZZ7HUTtWYBerrN36a7RqsHjYQb+bwG1JagY=";
      "d3d12-0.7.0" = "sha256-FqAVwW2jtDE1BV31OfrCJljGhj5iD0OfN2fANQ1wasc=";
      "fc-blackbox-0.2.0" = "sha256-gL8m9DpHJPVD8vvrmuYv+biJT4PA5LmtohJwFVO+khU=";
      "glow-0.13.0" = "sha256-vhPWzsm7NZx9JiRZcVoUslTGySQbASRh/wNlo1nK5jg=";
      "keep-awake-0.1.0" = "sha256-EoXhK4/Aij70f73+5NBUoCXqZISG1+n2eVavNqe8mq4=";
      "nshare-0.9.0" = "sha256-PAV41mMLDmhkAz4+qyf+MZnYTAdMwjk83+f+RdaJji8=";
      "qmetaobject-0.2.10" = "sha256-ldmpbOYoCOaAoipfcCSwuV+fzF9gg1PTbRz2Jm4zJvA=";
      "qml-video-rs-0.1.0" = "sha256-rwdci0QhGYOnCf04u61xuon06p8Zm2wKCNrW/qti9+U=";
      "rs-sync-0.1.0" = "sha256-sfym7zv5SUitopqNJ6uFP6AMzAGf4Y7U0dzXAKlvuGA=";
      "simplelog-0.12.0" = "sha256-NvmtLbzahSw1WMS3LY+jWiX4SxfSRwidTMvICGcmDO4=";
      "system_shutdown-4.0.1" = "sha256-arJWmEjDdaig/oAfwSolVmk9s1UovrQ5LNUgTpUvoOQ=";
      "telemetry-parser-0.2.8" = "sha256-Nr4SWEERKEAiZppqzjn1LIuMiZ2BTQEOKOlSnLVAXAg=";
    };
  };

  lens-profiles = callPackage ./lens-profiles.nix { };

  nativeBuildInputs = [
    clang
    copyDesktopItems
    patchelf
    pkg-config
    rustPlatform.bindgenHook
    wrapQtAppsHook
  ];

  buildInputs = [
    alsa-lib
    bash
    ffmpeg
    mdk-sdk
    ocl-icd
    opencv
    qtbase
    qtdeclarative
    qtsvg
  ];

  patches = [ ./no-static-zlib.patch ];

  # qml-video-rs and gyroflow assume that all Qt headers are installed
  # in a single (qtbase) directory.  Apart form QtCore and QtGui from
  # qtbase they need QtQuick and QtQml public and private headers from
  # qtdeclarative:
  # https://github.com/AdrianEddy/qml-video-rs/blob/bbf60090b966f0df2dd016e01da2ea78666ecea2/build.rs#L22-L40
  # https://github.com/gyroflow/gyroflow/blob/v1.5.4/build.rs#L163-L186
  # Additionally gyroflow needs QtQuickControls2:
  # https://github.com/gyroflow/gyroflow/blob/v1.5.4/build.rs#L173
  env.NIX_CFLAGS_COMPILE = toString [
    "-I${qtdeclarative}/include/QtQuick"
    "-I${qtdeclarative}/include/QtQuick/${qtdeclarative.version}"
    "-I${qtdeclarative}/include/QtQuick/${qtdeclarative.version}/QtQuick"
    "-I${qtdeclarative}/include/QtQml"
    "-I${qtdeclarative}/include/QtQml/${qtdeclarative.version}"
    "-I${qtdeclarative}/include/QtQml/${qtdeclarative.version}/QtQml"
    "-I${qtdeclarative}/include/QtQuickControls2"
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
    (makeDesktopItem (rec {
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

  meta = with lib; {
    description = "Advanced gyro-based video stabilization tool";
    homepage = "https://gyroflow.xyz/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ orivej ];
    platforms = [ "x86_64-linux" ];
  };
}
