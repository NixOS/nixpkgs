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
<<<<<<< HEAD
    version = "2.2.55";
    hash = "sha256-6jblQakNpoSQXfy5pU68Aedg661VcwpqQilvqOV15pQ=";
=======
    version = "2.2.54";
    hash = "sha256-rR7hrNX7BE86x51yaqvTKGfcc8ESnniFNOZ8Bu1Yzuc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  guiPreview = mkGui {
    channel = "stable";
<<<<<<< HEAD
    version = "2.2.55";
    hash = "sha256-6jblQakNpoSQXfy5pU68Aedg661VcwpqQilvqOV15pQ=";
=======
    version = "2.2.54";
    hash = "sha256-rR7hrNX7BE86x51yaqvTKGfcc8ESnniFNOZ8Bu1Yzuc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  serverStable = mkServer {
    channel = "stable";
<<<<<<< HEAD
    version = "2.2.55";
    hash = "sha256-o04RrHYsa5sWYUBDLJ5xgcK4iJK8CfZ4YdAiZ4eV/o4=";
=======
    version = "2.2.54";
    hash = "sha256-ih/9zIJtex9ikZ4oCuyYEjZ3U/BtxDojOz6FnJ0HOYU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  serverPreview = mkServer {
    channel = "stable";
<<<<<<< HEAD
    version = "2.2.55";
    hash = "sha256-o04RrHYsa5sWYUBDLJ5xgcK4iJK8CfZ4YdAiZ4eV/o4=";
=======
    version = "2.2.54";
    hash = "sha256-ih/9zIJtex9ikZ4oCuyYEjZ3U/BtxDojOz6FnJ0HOYU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
