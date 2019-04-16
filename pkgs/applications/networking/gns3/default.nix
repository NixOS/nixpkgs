{ callPackage, stdenv }:

let
  stableVersion = "2.1.16";
  previewVersion = "2.2.0a5";
  addVersion = args:
    let version = if args.stable then stableVersion else previewVersion;
        branch = if args.stable then "stable" else "preview";
    in args // { inherit version branch; };
  mkGui = args: callPackage (import ./gui.nix (addVersion args)) { };
  mkServer = args: callPackage (import ./server.nix (addVersion args)) { };
  guiSrcHash = "03d7yjdnks568njkrgyh7g6c3vf6v7wkifshz2bcvry79pp2h4nl";
  serverSrcHash = "0p331aaqxw16kk5l2074qn9a7ih6fkivm05n8da3fwydzp9hjmcp";
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
