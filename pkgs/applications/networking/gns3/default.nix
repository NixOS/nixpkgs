{ callPackage, stdenv }:

let
  stableVersion = "2.1.20";
  previewVersion = "2.2.0b2";
  addVersion = args:
    let version = if args.stable then stableVersion else previewVersion;
        branch = if args.stable then "stable" else "preview";
    in args // { inherit version branch; };
  mkGui = args: callPackage (import ./gui.nix (addVersion args)) { };
  mkServer = args: callPackage (import ./server.nix (addVersion args)) { };
  guiSrcHash = "0hs4qxas8xfwpn8c0w1l89aypqj3dy5wskyis8dq08p6h3kjis1g";
  serverSrcHash = "06q5283mdafijbczd14whw8fqwhmkvvaa9r7q16m18d96mr1z8m5";
in {
  guiStable = mkGui {
    stable = true;
    sha256Hash = guiSrcHash;
  };
  guiPreview = mkGui {
    stable = false;
    sha256Hash = "0hb22z7vd69dq6nayyyndlyqsnxb3lzgw3ac6m3fnxkv18n1nm6v";
  };

  serverStable = mkServer {
    stable = true;
    sha256Hash = serverSrcHash;
  };
  serverPreview = mkServer {
    stable = false;
    sha256Hash = "1a6ki0asai9x8xm724kha9phr2z8vkqfjwv067p860dpv2d2crxc";
  };
}
