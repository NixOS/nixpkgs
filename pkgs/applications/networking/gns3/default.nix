{ callPackage, stdenv }:

let
  stableVersion = "2.1.17";
  previewVersion = "2.2.0a5";
  addVersion = args:
    let version = if args.stable then stableVersion else previewVersion;
        branch = if args.stable then "stable" else "preview";
    in args // { inherit version branch; };
  mkGui = args: callPackage (import ./gui.nix (addVersion args)) { };
  mkServer = args: callPackage (import ./server.nix (addVersion args)) { };
  guiSrcHash = "1caqb644nq0hhszlg3ac87730m1xmw48b17jisqiq7zmk9scsh40";
  serverSrcHash = "0zyfh5sw8r2n41v0nazgdbr50cz6g5an2myvlgj5xx41smr9gflb";
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
