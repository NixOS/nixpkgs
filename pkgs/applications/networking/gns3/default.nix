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
    version = "2.2.46";
    hash = "sha256-i/Eq66dYDGR4RLJ76ZlKruhU0KC9KlMMf8Wb91ZoyY0=";
  };

  guiPreview = mkGui {
    channel = "stable";
    version = "2.2.46";
    hash = "sha256-i/Eq66dYDGR4RLJ76ZlKruhU0KC9KlMMf8Wb91ZoyY0=";
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
