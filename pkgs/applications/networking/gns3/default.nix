{ callPackage
, libsForQt5
}:

let
  mkGui = args: callPackage (import ./gui.nix (args)) {
    inherit (libsForQt5) wrapQtAppsHook;
  };

  mkServer = args: callPackage (import ./server.nix (args)) { };
in {

  guiStable = mkGui {
    channel = "stable";
    version = "2.2.44.1";
    hash = "sha256-Ae1Yij81/rhZOMMfLYaQKR4Dxx1gDGZBpBj0gLCSToI=";
  };

  guiPreview = mkGui {
    channel = "stable";
    version = "2.2.44.1";
    hash = "sha256-Ae1Yij81/rhZOMMfLYaQKR4Dxx1gDGZBpBj0gLCSToI=";
  };

  serverStable = mkServer {
    channel = "stable";
    version = "2.2.45";
    hash = "sha256-1GwhZEPfRW1e+enJipy7YOnA4QzeqZ7aCG92GrsZhms=";
  };

  serverPreview = mkServer {
    channel = "stable";
    version = "2.2.45";
    hash = "sha256-1GwhZEPfRW1e+enJipy7YOnA4QzeqZ7aCG92GrsZhms=";
  };
}
