{ callPackage, stdenv }:

let
  stableVersion = "2.1.1";
  previewVersion = "2.1.1";
  addVersion = args:
    let version = if args.stable then stableVersion else previewVersion;
        branch = if args.stable then "stable" else "preview";
    in args // { inherit version branch; };
  mkGui = args: callPackage (import ./gui.nix (addVersion args)) { };
  mkServer = args: callPackage (import ./server.nix (addVersion args)) { };
in {
  guiStable = mkGui {
    stable = true;
    sha256Hash = "1iyp5k8z3y32rv8wq268dk92vms5vhhhijxphwvfndh743jaynyk";
  };
  guiPreview = mkGui {
    stable = false;
    sha256Hash = "1iyp5k8z3y32rv8wq268dk92vms5vhhhijxphwvfndh743jaynyk";
  };

  serverStable = mkServer {
    stable = true;
    sha256Hash = "0d427p1g7misbryrn3yagpgxcjwiim39g11zzisw2744l116p7pv";
  };
  serverPreview = mkServer {
    stable = false;
    sha256Hash = "0d427p1g7misbryrn3yagpgxcjwiim39g11zzisw2744l116p7pv";
  };
}
