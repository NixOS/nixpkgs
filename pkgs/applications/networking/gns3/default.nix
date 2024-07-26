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
    version = "2.2.45";
    hash = "sha256-SMnhPz5zTPtidy/BIvauDM60WgDLG+NIr9rdUrQhz0A=";
  };

  guiPreview = mkGui {
    channel = "stable";
    version = "2.2.45";
    hash = "sha256-SMnhPz5zTPtidy/BIvauDM60WgDLG+NIr9rdUrQhz0A=";
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
