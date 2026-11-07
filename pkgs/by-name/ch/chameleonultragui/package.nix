{
  lib,
  flutter335,
  fetchFromGitHub,
  autoPatchelfHook,
  zenity,
  ninja,
  libserialport,
}:

flutter335.buildFlutterApplication rec {
  pname = "chameleonultragui";
  version = "1.3-stableish-2026-09-23";
  # “Main is assumed stable ish and everything builds from main and thats it”
  # — GameTec-live https://github.com/GameTec-live/ChameleonUltraGUI/pull/1008#issuecomment-5847621957

  src = fetchFromGitHub {
    owner = "GameTec-live";
    repo = "ChameleonUltraGUI";
    rev = "9d26ad61adca08da10b5ab6b9f6750d2db1cabc9";
    hash = "sha256-VAfkBjPb18SjKjJya2oRAmV3y3M3lepST3v+9bzJYOE=";
  };

  sourceRoot = "${src.name}/chameleonultragui";

  # curl https://raw.githubusercontent.com/GameTec-live/ChameleonUltraGUI/main/chameleonultragui/pubspec.lock | yq > pubspec.lock.json
  pubspecLock = lib.importJSON ./pubspec.lock.json;
  gitHashes = lib.importJSON ./git_hashes.json;

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    zenity
    ninja
    libserialport
  ];

  runtimeDependencies = [
    libserialport
  ];

  postInstall = ''
    install -Dm0644 aur/chameleonultragui.desktop $out/share/applications/chameleonultragui.desktop
    install -Dm0644 aur/chameleonultragui.png $out/share/icons/chameleonultragui.png
  '';

  meta = {
    description = "Cross platform GUI for the Chameleon Ultra written in flutter";
    homepage = "https://github.com/GameTec-live/ChameleonUltraGUI";
    changelog = "https://github.com/GameTec-live/ChameleonUltraGUI/releases/dev";
    license = with lib.licenses; [
      gpl3Only # main

      asl20 # chameleonultragui/assets/fonts/
      bsd3 # chameleonultragui/lib/helpers/font.dart
      # chameleonultragui/src/
      gpl2Plus # hardnested/, crapto1, crypto1, mfkey, parity
      mit # hardnested/, minlzlib/
      gpl3Plus # pm3/, hardnested.{c,h}
    ];
    platforms = lib.platforms.linux;
    mainProgram = "chameleonultragui";
    maintainers = with lib.maintainers; [
      Merikei
      wilaz
    ];
  };
}
