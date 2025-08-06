{
  lib,
  flutter329,
  plant-it,
}:

flutter329.buildFlutterApplication {
  pname = "plant-it-frontend";
  inherit (plant-it) version src;

  sourceRoot = "${plant-it.src.name}/frontend";

  targetFlutterPlatform = "web";

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  meta = plant-it.meta // {
    description = "Frontend for Plant It";
    platforms = lib.platforms.linux;
  };
}
