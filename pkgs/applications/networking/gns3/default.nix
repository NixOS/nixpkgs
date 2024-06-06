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
    version = "2.2.47";
    hash = "sha256-6UXQTPkRHbtNX6RzWMakCsO9YpkFlWliNnm+mZ4wuZA=";
  };

  guiPreview = mkGui {
    channel = "stable";
    version = "2.2.47";
    hash = "sha256-6UXQTPkRHbtNX6RzWMakCsO9YpkFlWliNnm+mZ4wuZA=";
  };

  serverStable = mkServer {
    channel = "stable";
    version = "2.2.46";
    hash = "sha256-A6rAhc/EGvbqVdg1jXxNX3bKQLcGurqa7hKh9LvH+es=";
  };

  serverPreview = mkServer {
    channel = "stable";
    version = "2.2.46";
    hash = "sha256-A6rAhc/EGvbqVdg1jXxNX3bKQLcGurqa7hKh9LvH+es=";
  };
}
