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
  version = "1.5.4-2024-09-05";

  src = fetchFromGitHub {
    owner = "gyroflow";
    repo = "gyroflow";
    rev = "52038dedad0bd14d6af68db36a09da0243ad5455";
    hash = "sha256-EuhUF2b8YWv2eN2pcoHA0SlnyeQ8gJ5eHbXi6G4GIzk=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ahrs-0.6.0" = "sha256-CxWyX8t+BjqIyNj1p1LdkCmNrtJkudmKgZPv0MVcghY=";
      "akaze-0.7.0" = "sha256-KkGXKoVRZZ7HUTtWYBerrN36a7RqsHjYQb+bwG1JagY=";
      "app_dirs2-2.5.5" = "sha256-nQ5Cs9r1k/3zjqXJ18Oilk8ErLKim7bGwCXDlQW4GRQ=";
      "fc-blackbox-0.2.0" = "sha256-82DuI0KuHhDVhCMUsnDqk6Fk774VpvoJ1qYFLO+n1X4=";
      "ffmpeg-next-7.0.4" = "sha256-F1N70tSxdC36uS9Bh7X2S9Wspd7bcCbGPmoMRs1cm8Y=";
      "ffmpeg-sys-next-7.0.2" = "sha256-7C46WJseKIhqXW0cQGaF8Q/xQi7sX+e8fKVrhBMVwZE=";
      "keep-awake-0.1.0" = "sha256-iZuntDkAhDZBojRgNEupAExtqOhiw4mf6XK0N6ff2Oc=";
      "mp4parse-0.17.0" = "sha256-DktX6zmQsHBlo7uLgLXcXWxKq9uisnX0R16lftWRLZY=";
      "naga-22.0.0" = "sha256-+ngomv0VyWKNDkSGVI/f5wtDyLs79qiXxtj3qNOsbFc=";
      "nshare-0.9.0" = "sha256-PAV41mMLDmhkAz4+qyf+MZnYTAdMwjk83+f+RdaJji8=";
      "qmetaobject-0.2.10" = "sha256-kEwFjDe1tYTLQ8XdjrPyYEYnjVFyYeaWUPCj5D8mg7A=";
      "qml-video-rs-0.1.0" = "sha256-8RYB+numVy7u29EYtSSdf/+cTsUMVjrcw4u5mqB7KbE=";
      "rs-sync-0.1.0" = "sha256-6xQb0CUlBDx7S7zsqNL9zfZZtkmw0cbUUXd6pOYIrXI=";
      "spirv-std-0.9.0" = "sha256-uZn1p2pM5UYQKlY9u16aafPH7dfQcSG7PaFDd1sT4Qc=";
      "system_shutdown-4.0.1" = "sha256-YypNnZzTxkmUgIxaP4jOpFBje/fEzI5L1g+3pJgMd0w=";
      "telemetry-parser-0.3.0" = "sha256-U26cWC7pSw4NFiu43BZf+KlLy9NU61iRpFx3Btse1aY=";
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
