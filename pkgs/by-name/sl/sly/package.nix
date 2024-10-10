{
  lib,
  fetchFromGitHub,
  flutter,
  stdenv,
  autoPatchelfHook,
  makeDesktopItem,
  copyDesktopItems,
}:
let
  version = "0.3.4";
  src = fetchFromGitHub {
    owner = "kra-mo";
    repo = "sly";
    rev = "v${version}";
    hash = "sha256-5YEiUAagB6dwm4zJuhEGcWyJwTwlABNFzLYv27eKZKQ=";
  };
in
flutter.buildFlutterApplication {
  pname = "sly";

  inherit version src;

  desktopItems = [
    (makeDesktopItem {
      name = "Sly";
      exec = "sly";
      comment = "Friendly image editor";
      icon = "page.kramo.Sly";
      genericName = "Image Editor";
      desktopName = "Sly";
      categories = [
        "Utility"
        "Graphics"
        "2DGraphics"
        "RasterGraphics"
      ];
      keywords = [
        "image"
        "photo"
        "editor"
      ];
    })
  ];

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  nativeBuildInputs = [
    copyDesktopItems
    autoPatchelfHook
  ];

  postInstall = ''
    install -Dm0644 ${src}/packaging/linux/page.kramo.Sly.svg $out/share/icons/hicolor/symbolic/apps/page.kramo.Sly.svg
  '';

  meta = {
    description = "Friendly image editor";
    homepage = "https://github.com/kra-mo/sly";
    mainProgram = "sly";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ aucub ];
    platforms = lib.platforms.darwin ++ [ "x86_64-linux" ];
    broken = stdenv.hostPlatform.isDarwin;
  };
}
