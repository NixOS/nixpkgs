{
  lib,
  flutter326,
  nix-update-script,
  plant-it,
}:

flutter326.buildFlutterApplication {
  pname = "plant-it-frontend";
  inherit (plant-it) version;
  src = "${plant-it.root-src}/frontend";

  targetFlutterPlatform = "web";

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  passthru.updateScript = nix-update-script { };

  meta = plant-it.meta // {
    description = "Frontend for Plant It.";
  };
}
