{
  lib,
  flutter326,
  plant-it,
}:

flutter326.buildFlutterApplication {
  pname = "plant-it-frontend";
  inherit (plant-it) version src;
  sourceRoot = "source/frontend";

  targetFlutterPlatform = "web";

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  meta = plant-it.meta // {
    description = "Frontend for Plant It";
  };
}
