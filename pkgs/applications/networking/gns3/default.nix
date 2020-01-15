{ callPackage }:

let
  stableVersion = "2.1.21";
  previewVersion = "2.2.0rc4";
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
    sha256Hash = "14fzjaanaxya97wrya2lybxz6qv72fk4ws8i92zvjz4jkvjdk9n3";
  };

  serverStable = mkServer {
    stable = true;
    sha256Hash = serverSrcHash;
  };
  serverPreview = mkServer {
    stable = false;
    sha256Hash = "03s2kq5f8whk14rhprg9yp3918641b1cwj6djcbjw8xpz0n3w022";
  };
}
