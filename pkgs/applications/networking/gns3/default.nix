{ callPackage, stdenv }:

let
  stableVersion = "2.1.15";
  previewVersion = "2.2.0a3";
  addVersion = args:
    let version = if args.stable then stableVersion else previewVersion;
        branch = if args.stable then "stable" else "preview";
    in args // { inherit version branch; };
  mkGui = args: callPackage (import ./gui.nix (addVersion args)) { };
  mkServer = args: callPackage (import ./server.nix (addVersion args)) { };
  guiSrcHash = "116wigkh5kwna00q200yv2wm8dpi4kmsns96iglzwrrl19fk538p";
  serverSrcHash = "1mqwydxn58v5ddpnsxvf6vgqwhrfm3mwjwf030lv83zmcjhx237q";
in {
  guiStable = mkGui {
    stable = true;
    sha256Hash = guiSrcHash;
  };
  guiPreview = mkGui {
    stable = false;
    sha256Hash = "110mghkhanz92p8vfzyh4199mnihb24smxsc44a8v534ds6hww74";
  };

  serverStable = mkServer {
    stable = true;
    sha256Hash = serverSrcHash;
  };
  serverPreview = mkServer {
    stable = false;
    sha256Hash = "104pvrba7n9gp7mx31xg520cfahcy0vsmbzx23007c50kp0nxc56";
  };
}
