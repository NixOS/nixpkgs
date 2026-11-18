{
  lib,
  flutter347,
  fetchFromGitHub,
  autoPatchelfHook,
  zenity,
  ninja,
  libserialport,
}:

flutter347.buildFlutterApplication rec {
  pname = "chameleonultragui";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "GameTec-live";
    repo = "ChameleonUltraGUI";
    tag = version;
    hash = "sha256-4TgnHnymipSaC0Gi4tmWwNrXGyfWG5alNaqBbr6nw7Y=";
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
    install -Dm0644 build/linux/*/release/shared/librecovery.so $out/app/chameleonultragui/lib
  '';

  meta = {
    description = "Cross platform GUI for the Chameleon Ultra written in flutter";
    homepage = "https://github.com/GameTec-live/ChameleonUltraGUI";
    changelog = "https://github.com/GameTec-live/ChameleonUltraGUI/releases/${version}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.linux;
    mainProgram = "chameleonultragui";
    maintainers = with lib.maintainers; [ wilaz ];
  };
}
