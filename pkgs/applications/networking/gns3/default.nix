{ callPackage
, libsForQt5
, python311Packages
}:

let
  mkGui = args: callPackage (import ./gui.nix (args)) {
    inherit (libsForQt5) wrapQtAppsHook;
    python3Packages = python311Packages;
  };

  mkServer = args: callPackage (import ./server.nix (args)) { };
in
{
  guiStable = mkGui {
    channel = "stable";
    version = "2.2.49";
    hash = "sha256-hvLJ4VilcgtpxHeboeSUuGAco9LEnUB8J6vy/ZPajbU=";
  };

  guiPreview = mkGui {
    channel = "stable";
    version = "2.2.49";
    hash = "sha256-hvLJ4VilcgtpxHeboeSUuGAco9LEnUB8J6vy/ZPajbU=";
  };

  serverStable = mkServer {
    channel = "stable";
    version = "2.2.49";
    hash = "sha256-fI49MxA6b2kPkUihLl32a6jo8oHcEwDEjmvSVDj8/So=";
  };

  serverPreview = mkServer {
    channel = "stable";
    version = "2.2.49";
    hash = "sha256-fI49MxA6b2kPkUihLl32a6jo8oHcEwDEjmvSVDj8/So=";
  };
}
