{
  commonMeta,
  multipass_src,
  multipassd,
  version,

  autoPatchelfHook,
  flutter327,
  gtkmm3,
  keybinder3,
  lib,
  libayatana-appindicator,
  libnotify,
  protobuf,
  protoc-gen-dart,
  qt6,
}:
flutter327.buildFlutterApplication {
  inherit version;
  pname = "multipass-gui";
  src = multipass_src;

  sourceRoot = "${multipass_src.name}/src/client/gui";

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    dartssh2 = "sha256-2pypKwurziwGLZYuGaxlS2lzN3UvJp3bRTvvYYxEqRI=";
    hotkey_manager_linux = "sha256-aO0h94YZvgV/ggVupNw8GjyZsnXrq3qTHRDtuhNv3oI=";
    system_info2 = "sha256-fly7E2vG+bQ/+QGzXk+DYba73RZccltdW2LpZGDKX60=";
    tray_menu = "sha256-riiAiBEms+9ARog8i+MR1fto1Yqx+gwbBWyNbNq6VTM=";
    window_size = "sha256-71PqQzf+qY23hTJvcm0Oye8tng3Asr42E2vfF1nBmVA=";
    xterm = "sha256-h8vIonTPUVnNqZPk/A4ZV7EYCMyM0rrErL9ZOMe4ZBE=";
  };

  buildInputs = [
    gtkmm3
    keybinder3
    libayatana-appindicator
    libnotify
    qt6.qtbase
    qt6.qtwayland
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    protobuf
    protoc-gen-dart
    qt6.wrapQtAppsHook
  ];

  preBuild = ''
    mkdir -p lib/generated

    # Generate the Dart gRPC code for the Multipass GUI.
    protoc \
      --plugin=protoc-gen-dart=${lib.getExe protoc-gen-dart} \
      --dart_out=grpc:lib/generated \
      -I ../../rpc \
      ../../rpc/multipass.proto \
      google/protobuf/timestamp.proto
  '';

  runtimeDependencies = [ multipassd ];

  postFixup = ''
    mv $out/bin/multipass_gui $out/bin/multipass.gui

    install -Dm444 $out/app/multipass-gui/data/flutter_assets/assets/icon.png \
      $out/share/icons/hicolor/256x256/apps/multipass.gui.png

    cp $out/share/applications/multipass.gui.autostart.desktop \
      $out/share/applications/multipass.gui.desktop
  '';

  meta = commonMeta // {
    description = "Flutter frontend application for managing Ubuntu VMs";
  };
}
