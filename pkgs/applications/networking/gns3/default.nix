{ callPackage, libsForQt5 }:

let
  stableVersion = "2.2.15";
  previewVersion = stableVersion;
  addVersion = args:
    let version = if args.stable then stableVersion else previewVersion;
        branch = if args.stable then "stable" else "preview";
    in args // { inherit version branch; };
  extraArgs = rec {
    mkOverride = attrname: version: sha256:
      self: super: {
        ${attrname} = super.${attrname}.overridePythonAttrs (oldAttrs: {
          inherit version;
          src = oldAttrs.src.override {
            inherit version sha256;
          };
        });
      };
    commonOverrides = [
      (mkOverride "psutil" "5.6.7"
        "1an5llivfkwpbcfaapbx78p8sfnvzyfypf60wfxihib1mjr8xbgz")
      (mkOverride "jsonschema" "3.2.0"
        "0ykr61yiiizgvm3bzipa3l73rvj49wmrybbfwhvpgk3pscl5pa68")
    ];
  };
  mkGui = args: libsForQt5.callPackage (import ./gui.nix (addVersion args // extraArgs)) { };
  mkServer = args: callPackage (import ./server.nix (addVersion args // extraArgs)) { };
  guiSrcHash = "149yphmxc47bhc2f942lp4bx354qj3cyrpn10s1xabkn2hwrsm0d";
  serverSrcHash = "03cfg48xzgz362ra5x853k8r244dgbrmszcprs2lg70i3m722345";
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
