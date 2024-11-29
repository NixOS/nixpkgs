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
    version = "2.2.50";
    hash = "sha256-A6aLp/fN/0u5VIOX6d0QrZ2zWuNPvhI1xfw7cKU9jRA=";
  };

  guiPreview = mkGui {
    channel = "stable";
    version = "2.2.50";
    hash = "sha256-A6aLp/fN/0u5VIOX6d0QrZ2zWuNPvhI1xfw7cKU9jRA=";
  };

  serverStable = mkServer {
    channel = "stable";
    version = "2.2.50";
    hash = "sha256-m5Od3IPn31JaFOtilKh79aISH4lRd+KatSLRqsF8n4Y=";
  };

  serverPreview = mkServer {
    channel = "stable";
    version = "2.2.50";
    hash = "sha256-m5Od3IPn31JaFOtilKh79aISH4lRd+KatSLRqsF8n4Y=";
  };
}
