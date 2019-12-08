{ callPackage }:

let
  stableVersion = "2.2.3";
  previewVersion = stableVersion;
  addVersion = args:
    let version = if args.stable then stableVersion else previewVersion;
        branch = if args.stable then "stable" else "preview";
    in args // { inherit version branch; };
  mkGui = args: callPackage (import ./gui.nix (addVersion args)) { };
  mkServer = args: callPackage (import ./server.nix (addVersion args)) { };
  guiSrcHash = "1l40q3d3hsmhgwb4d8hj73vhgckm0dvsc6l6qzacypd202iq1v8a";
  serverSrcHash = "1qcypb1rmfdl8fl3ykqf5phcapmjid6jrxd6xpncd5dhyl2hr94n";
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
