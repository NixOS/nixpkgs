{
  callPackage,
  libsForQt5,
}:

let
  mkGui =
    args:
    callPackage (import ./gui.nix args) {
      inherit (libsForQt5) wrapQtAppsHook;
    };

  mkServer = args: callPackage (import ./server.nix args) { };
in
{
  guiStable = mkGui {
    channel = "stable";
    version = "2.2.54";
    hash = "sha256-rR7hrNX7BE86x51yaqvTKGfcc8ESnniFNOZ8Bu1Yzuc=";
  };

  guiPreview = mkGui {
    channel = "stable";
    version = "2.2.54";
    hash = "sha256-rR7hrNX7BE86x51yaqvTKGfcc8ESnniFNOZ8Bu1Yzuc=";
  };

  serverStable = mkServer {
    channel = "stable";
    version = "2.2.54";
    hash = "sha256-ih/9zIJtex9ikZ4oCuyYEjZ3U/BtxDojOz6FnJ0HOYU=";
  };

  serverPreview = mkServer {
    channel = "stable";
    version = "2.2.54";
    hash = "sha256-ih/9zIJtex9ikZ4oCuyYEjZ3U/BtxDojOz6FnJ0HOYU=";
  };
}
