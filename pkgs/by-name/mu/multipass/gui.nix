{
  commonMeta,
  multipass_src,
  multipassd,
  version,

  autoPatchelfHook,
  flutter332,
  gtkmm3,
  keybinder3,
  lib,
  libayatana-appindicator,
  libnotify,
  protobuf,
  protoc-gen-dart,
  qt6,
}:
flutter332.buildFlutterApplication {
  inherit version;
  pname = "multipass-gui";
  src = multipass_src;

  sourceRoot = "${multipass_src.name}/src/client/gui";

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes = {
    dartssh2 = "sha256-9XrxxOamy0uS7kUz6mwWwp4yIBHLX/GSoyxMk/Wwa+4=";
    hotkey_manager_linux = "sha256-aO0h94YZvgV/ggVupNw8GjyZsnXrq3qTHRDtuhNv3oI=";
    tray_menu = "sha256-TAlRW7VkZWAoHAVlrPeDqS3BsqhQTyCekYQ2b4AEqjU=";
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
    # Temporary fix which can be removed in the next release.
    # Already addressed upstream, but part of a larger patch
    # that did not trivially apply.
    substituteInPlace lib/main.dart --replace-fail 'TabBarTheme(' 'TabBarThemeData('

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
