{
  lib,
  flutter329,
  fetchFromGitHub,
  autoPatchelfHook,
  mpv,
  makeDesktopItem,
  copyDesktopItems,
}:

flutter329.buildFlutterApplication rec {
  pname = "simple-live-app";
  version = "1.7.7";

  src = fetchFromGitHub {
    owner = "xiaoyaocz";
    repo = "dart_simple_live";
    tag = "v${version}";
    hash = "sha256-NK1qIlxgSZQ1Es3KhMcUc1Je5ATq53kXcBqLBQVw5DQ=";
  };

  sourceRoot = "${src.name}/simple_live_app";

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  gitHashes.ns_danmaku = "sha256-Hzp5QsdgBStaPVSHdHul7ZqOhZHQS9dbO+RpC4wMYqo=";

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
  ];

  buildInputs = [ mpv ];

  desktopItems = [
    (makeDesktopItem {
      name = "simple-live-app";
      exec = "simple_live_app";
      icon = "simple-live-app";
      genericName = "Simple-Live";
      desktopName = "Simple-Live";
      keywords = [ "Simple Live" ];
    })
  ];

  postInstall = ''
    install -Dm644 assets/logo.png $out/share/pixmaps/simple-live-app.png
  '';

  extraWrapProgramArgs = ''
    --prefix LD_LIBRARY_PATH : $out/app/simple-live-app/lib
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Simply Watch Live";
    homepage = "https://github.com/xiaoyaocz/dart_simple_live";
    mainProgram = "simple_live_app";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
}
