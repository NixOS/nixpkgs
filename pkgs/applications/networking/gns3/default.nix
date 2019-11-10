{ callPackage }:

let
  stableVersion = "2.2.2";
  previewVersion = "2.2.2";
  addVersion = args:
    let version = if args.stable then stableVersion else previewVersion;
        branch = if args.stable then "stable" else "preview";
    in args // { inherit version branch; };
  mkGui = args: callPackage (import ./gui.nix (addVersion args)) { };
  mkServer = args: callPackage (import ./server.nix (addVersion args)) { };
  guiSrcHash = "0i335fjbadixp39l75w0fl5iwz2cb8rcdj2xvx1my3vzhg8lijfl";
  serverSrcHash = "1g6km8jc53y8ph14ifjxscbimdxma6bw5ir9gqzvkjn39k9fy1w6";
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
