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
    version = "2.2.43";
    hash = "sha256-+2dcyWnTJqGaH9yhknYc9/0gnj3qh80eAy6uxG7+fFM=";
  };

  guiPreview = mkGui {
    channel = "stable";
    version = "2.2.43";
    hash = "sha256-+2dcyWnTJqGaH9yhknYc9/0gnj3qh80eAy6uxG7+fFM=";
  };

  serverStable = mkServer {
    channel = "stable";
    version = "2.2.43";
    hash = "sha256-xWt2qzeqBtt86Wv3dYl4GXkfjr+7WAKn5HdDeUzOQd8=";
  };

  serverPreview = mkServer {
    channel = "stable";
    version = "2.2.43";
    hash = "sha256-xWt2qzeqBtt86Wv3dYl4GXkfjr+7WAKn5HdDeUzOQd8=";
  };
}
