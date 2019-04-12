{ callPackage, stdenv }:

let
  stableVersion = "2.1.15";
  previewVersion = "2.2.0a4";
  addVersion = args:
    let version = if args.stable then stableVersion else previewVersion;
        branch = if args.stable then "stable" else "preview";
    in args // { inherit version branch; };
  mkGui = args: callPackage (import ./gui.nix (addVersion args)) { };
  mkServer = args: callPackage (import ./server.nix (addVersion args)) { };
  guiSrcHash = "116wigkh5kwna00q200yv2wm8dpi4kmsns96iglzwrrl19fk538p";
  serverSrcHash = "1mqwydxn58v5ddpnsxvf6vgqwhrfm3mwjwf030lv83zmcjhx237q";
in {
  guiStable = mkGui {
    stable = true;
    sha256Hash = guiSrcHash;
  };
  guiPreview = mkGui {
    stable = false;
    sha256Hash = "1a64c314v7mbaiipyap2skqgf69pyp1ld58cn2g3d89w2zrhf5q7";
  };

  serverStable = mkServer {
    stable = true;
    sha256Hash = serverSrcHash;
  };
  serverPreview = mkServer {
    stable = false;
    sha256Hash = "1jlz8a34q3s1sz9r6swh3jnlp96602axnvh1byywry5fb9ga8mfy";
  };
}
