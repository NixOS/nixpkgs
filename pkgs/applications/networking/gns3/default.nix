{ callPackage
, libsForQt5
}:

let
<<<<<<< HEAD
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
=======
  stableVersion = "2.2.35.1";
  previewVersion = stableVersion;
  addVersion = args:
    let version = if args.stable then stableVersion else previewVersion;
        branch = if args.stable then "stable" else "preview";
    in args // { inherit version branch; };
  extraArgs = rec {
    mkOverride = attrname: version: sha256:
      self: super: {
        "${attrname}" = super."${attrname}".overridePythonAttrs (oldAttrs: {
          inherit version;
          src = oldAttrs.src.override {
            inherit version sha256;
          };
        });
      };
  };
  mkGui = args: libsForQt5.callPackage (import ./gui.nix (addVersion args // extraArgs)) { };
  mkServer = args: callPackage (import ./server.nix (addVersion args // extraArgs)) { };
  guiSrcHash = "sha256-iVvADwIp01HeZoDayvH1dilYRHRkRBTBR3Fh395JBq0=";
  serverSrcHash = "sha256-41dbiSjvmsDNYr9/rRkeQVOnPSVND34xx1SNknCgHfc=";

in {
  guiStable = mkGui {
    stable = true;
    sha256Hash = guiSrcHash;
  };
  guiPreview = mkGui {
    stable = false;
    sha256Hash = guiSrcHash;
  };

  serverStable = mkServer {
    stable = true;
    sha256Hash = serverSrcHash;
  };
  serverPreview = mkServer {
    stable = false;
    sha256Hash = serverSrcHash;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
