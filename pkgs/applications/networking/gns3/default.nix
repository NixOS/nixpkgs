{ callPackage }:

let
  stableVersion = "2.2.1";
  previewVersion = "2.2.1";
  addVersion = args:
    let version = if args.stable then stableVersion else previewVersion;
        branch = if args.stable then "stable" else "preview";
    in args // { inherit version branch; };
  mkGui = args: callPackage (import ./gui.nix (addVersion args)) { };
  mkServer = args: callPackage (import ./server.nix (addVersion args)) { };
  guiSrcHash = "16v2sdz37vm8x8w07qxaq2mbx169f9hqqpxnf1lq19v9dfhb19kh";
  serverSrcHash = "0liv9fwi2746542qpnvwzf5wcrsxfv6x5jypwd5db1qkfd50s8xa";
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
