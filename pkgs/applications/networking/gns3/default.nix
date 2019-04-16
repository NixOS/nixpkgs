{ callPackage, stdenv }:

let
  stableVersion = "2.1.15";
  previewVersion = "2.2.0a5";
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
    sha256Hash = "0p4g5hszys68ijzsi2rb89j1rpg04wlqlzzrl92npvqqf2i0jdf8";
  };

  serverStable = mkServer {
    stable = true;
    sha256Hash = serverSrcHash;
  };
  serverPreview = mkServer {
    stable = false;
    sha256Hash = "1yvdfczi8ah9m7b49l7larfs678hh7c424i1f73kivfds6211bj5";
  };
}
