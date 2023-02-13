{ callPackage
, libsForQt5
}:

let
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
  };
}
