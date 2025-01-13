{ callPackage
, libsForQt5
}:

let
  mkGui = args: callPackage (import ./gui.nix (args)) {
    inherit (libsForQt5) wrapQtAppsHook;
  };

  mkServer = args: callPackage (import ./server.nix (args)) { };
in
{
  guiStable = mkGui {
    channel = "stable";
    version = "2.2.51";
    hash = "sha256-HXuhaJEcr33qYm2v/wFqnO7Ba4lyZgSzvh6dkNZX9XI=";
  };

  guiPreview = mkGui {
    channel = "stable";
    version = "2.2.51";
    hash = "sha256-HXuhaJEcr33qYm2v/wFqnO7Ba4lyZgSzvh6dkNZX9XI=";
  };

  serverStable = mkServer {
    channel = "stable";
    version = "2.2.51";
    hash = "sha256-Yw6RvHZzVU2wWXVxvuIu7GLFyqjakwqJ0EV6H0ZdVcQ=";
  };

  serverPreview = mkServer {
    channel = "stable";
    version = "2.2.51";
    hash = "sha256-Yw6RvHZzVU2wWXVxvuIu7GLFyqjakwqJ0EV6H0ZdVcQ=";
  };
}

