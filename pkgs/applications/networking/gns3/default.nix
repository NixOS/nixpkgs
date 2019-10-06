{ callPackage }:

let
  stableVersion = "2.2.0";
  previewVersion = "2.2.0";
  addVersion = args:
    let version = if args.stable then stableVersion else previewVersion;
        branch = if args.stable then "stable" else "preview";
    in args // { inherit version branch; };
  mkGui = args: callPackage (import ./gui.nix (addVersion args)) { };
  mkServer = args: callPackage (import ./server.nix (addVersion args)) { };
  guiSrcHash = "0xghldzk126ly49y7drp241w7c0h9fb0ags9blk0rlq99i72as78";
  serverSrcHash = "0iphs0w6r9s85cgd95bh6jd0224ywilrzb7a4jjwi38z7a7id4gk";
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
