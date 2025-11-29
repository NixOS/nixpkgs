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
    version = "2.2.55";
    hash = "sha256-6jblQakNpoSQXfy5pU68Aedg661VcwpqQilvqOV15pQ=";
  };

  guiPreview = mkGui {
    channel = "stable";
    version = "2.2.55";
    hash = "sha256-6jblQakNpoSQXfy5pU68Aedg661VcwpqQilvqOV15pQ=";
  };

  serverStable = mkServer {
    channel = "stable";
    version = "2.2.55";
    hash = "sha256-o04RrHYsa5sWYUBDLJ5xgcK4iJK8CfZ4YdAiZ4eV/o4=";
  };

  serverPreview = mkServer {
    channel = "stable";
    version = "2.2.55";
    hash = "sha256-o04RrHYsa5sWYUBDLJ5xgcK4iJK8CfZ4YdAiZ4eV/o4=";
  };
}
