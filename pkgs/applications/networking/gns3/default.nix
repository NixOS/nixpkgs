{ callPackage, stdenv }:

let
  stableVersion = "2.1.4";
  # Currently there is no preview version.
  previewVersion = stableVersion;
  addVersion = args:
    let version = if args.stable then stableVersion else previewVersion;
        branch = if args.stable then "stable" else "preview";
    in args // { inherit version branch; };
  mkGui = args: callPackage (import ./gui.nix (addVersion args)) { };
  mkServer = args: callPackage (import ./server.nix (addVersion args)) { };
  guiSrcHash = "03x9qgqs4y9swyipigviyscvlcfkb2v6iasc54nv07ks8srqwf93";
  serverSrcHash = "0qzx0y4mqxpn5xhzgr2865lvszhi6szdli1jq64gihwdy3bhli4f";
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
