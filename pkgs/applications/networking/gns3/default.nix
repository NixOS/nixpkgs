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
    version = "2.2.48.1";
    hash = "sha256-v39tMKbw/1x09s/yA83SFYSLjH1+rmLiKzdm7gxLkXk=";
  };

  guiPreview = mkGui {
    channel = "stable";
    version = "2.2.48.1";
    hash = "sha256-v39tMKbw/1x09s/yA83SFYSLjH1+rmLiKzdm7gxLkXk=";
  };

  serverStable = mkServer {
    channel = "stable";
    version = "2.2.48.1";
    hash = "sha256-YtRblGJBsyyPRkPJnMbRU8YI5p9ctTqDYwkkb139ajY=";
  };

  serverPreview = mkServer {
    channel = "stable";
    version = "2.2.48.1";
    hash = "sha256-YtRblGJBsyyPRkPJnMbRU8YI5p9ctTqDYwkkb139ajY=";
  };
}
