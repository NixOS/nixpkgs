{
  autoPatchelfHook,
  lib,
  fetchFromGitHub,
  flutter324,
  mpv,
  alsa-lib,
  makeDesktopItem,
  copyDesktopItems,
}:

flutter324.buildFlutterApplication rec {
  pname = "pilipalax";
  version = "1.1.0-beta.5";

  src = fetchFromGitHub {
    owner = "orz12";
    repo = "PiliPalaX";
    tag = "${version}+180";
    hash = "sha256-bKs0EZjJCJvtVOZYl3GqXPE2MxX7DRjMwtmFUcNgrOQ=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  desktopItems = [
    (makeDesktopItem {
      name = "pilipalax";
      exec = "pilipala";
      icon = "pilipalax";
      genericName = "PiliPalaX";
      desktopName = "PiliPalaX";
    })
  ];

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = [
    mpv
    alsa-lib
  ];

  gitHashes = {
    auto_orientation = "sha256-0QOEW8+0PpBIELmzilZ8+z7ozNRxKgI0BzuBS8c1Fng=";
    canvas_danmaku = "sha256-HjTGFdbPeAGuGdgoTbW9q/soYey+DkPKdZrSKloQ6jA=";
    fl_pip = "sha256-vBIxU/FjcGPBpnHP/wZMEI8VX71RWuUi9LQJ89dBnvg=";
    flutter_floating = "sha256-V+RhmCD/Vb/G2Zr8FPgwSzzYlAcJcbqy0sYXyhXRwP8=";
  };

  postInstall = ''
    install -Dm644 ./assets/images/logo/logo_android_2.png $out/share/pixmaps/pilipalax.png
  '';

  extraWrapProgramArgs = ''
    --prefix LD_LIBRARY_PATH : $out/app/pilipalax/lib
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Third-party BiliBili client developed with Flutter";
    homepage = "https://github.com/orz12/PiliPalaX";
    mainProgram = "pilipala";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ aucub ];
    platforms = lib.platforms.linux;
  };
}
