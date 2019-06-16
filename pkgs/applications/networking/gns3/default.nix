{ callPackage }:

let
  stableVersion = "2.1.21";
  previewVersion = "2.2.0b3";
  addVersion = args:
    let version = if args.stable then stableVersion else previewVersion;
        branch = if args.stable then "stable" else "preview";
    in args // { inherit version branch; };
  mkGui = args: callPackage (import ./gui.nix (addVersion args)) { };
  mkServer = args: callPackage (import ./server.nix (addVersion args)) { };
  guiSrcHash = "1ydmib302r1cpm2z9pzsfp4ygxrbmskwszsip397n92qx3l9a9v3";
  serverSrcHash = "1ahn1xq1f0wx46i0c8idz96dxfbakk37pqi6amy91594mdlp8yr4";
in {
  guiStable = mkGui {
    stable = true;
    sha256Hash = guiSrcHash;
  };
  guiPreview = mkGui {
    stable = false;
    sha256Hash = "1bzy95zqinwrrga7qj6gvpzvz34w4ddhvgmpgq3p1lwzixpqg1w7";
  };

  serverStable = mkServer {
    stable = true;
    sha256Hash = serverSrcHash;
  };
  serverPreview = mkServer {
    stable = false;
    sha256Hash = "1bq4ww6qhhl0qw6yj7cf7yg54yb4y8mxlnwss6hgbyfv5fz9rxjp";
  };
}
