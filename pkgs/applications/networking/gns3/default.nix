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
    version = "2.2.42";
    hash = "sha256-FW8Nuha+NrYVhR/66AiBpcCLHRhiLTW8KdHFyWSao84=";
  };

  guiPreview = mkGui {
    channel = "stable";
    version = "2.2.42";
    hash = "sha256-FW8Nuha+NrYVhR/66AiBpcCLHRhiLTW8KdHFyWSao84=";
  };

  serverStable = mkServer {
    channel = "stable";
    version = "2.2.42";
    hash = "sha256-YM07krEay2W+/6mKLAg+B7VEnAyDlkD+0+cSO1FAJzA=";
  };

  serverPreview = mkServer {
    channel = "stable";
    version = "2.2.42";
    hash = "sha256-YM07krEay2W+/6mKLAg+B7VEnAyDlkD+0+cSO1FAJzA=";
  };
}
