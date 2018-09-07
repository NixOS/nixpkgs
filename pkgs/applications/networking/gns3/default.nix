{ callPackage, stdenv }:

let
  stableVersion = "2.1.9";
  # Currently there is no preview version.
  previewVersion = stableVersion;
  addVersion = args:
    let version = if args.stable then stableVersion else previewVersion;
        branch = if args.stable then "stable" else "preview";
    in args // { inherit version branch; };
  mkGui = args: callPackage (import ./gui.nix (addVersion args)) { };
  mkServer = args: callPackage (import ./server.nix (addVersion args)) { };
  guiSrcHash = "0gpif6f7zqz2n8q3pkr8xv3fdc904hq69661w8f1fna360xvksd7";
  serverSrcHash = "1y19jzyyz0sjjxkrpgr6z10irb47v7d8khdvk5nzmgnjfxv875yx";
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
