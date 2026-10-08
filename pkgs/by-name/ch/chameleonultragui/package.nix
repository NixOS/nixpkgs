{
  lib,
  flutter335,
  fetchFromGitHub,
  autoPatchelfHook,
  zenity,
  ninja,
}:

flutter335.buildFlutterApplication rec {
  pname = "chameleonultragui";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "GameTec-live";
    repo = "ChameleonUltraGUI";
    tag = version;
    hash = "sha256-9Hwjx1nt/QD520eLMAB5xyFjOGfjZSwS83ARNn8GsFo=";
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
  ];

  postPatch = ''
    substituteInPlace linux/main.cc \
      --replace-fail '"../shared", "librecovery.so"' '"lib", "librecovery.so"'
  '';

  postInstall = ''
    install -Dm0644 aur/chameleonultragui.desktop $out/share/applications/chameleonultragui.desktop
    install -Dm0644 aur/chameleonultragui.png $out/share/pixmaps/chameleonultragui.png
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
