{ callPackage, stdenv }:

let
  stableVersion = "2.1.12";
  # Currently there is no preview version.
  previewVersion = stableVersion;
  addVersion = args:
    let version = if args.stable then stableVersion else previewVersion;
        branch = if args.stable then "stable" else "preview";
    in args // { inherit version branch; };
  mkGui = args: callPackage (import ./gui.nix (addVersion args)) { };
  mkServer = args: callPackage (import ./server.nix (addVersion args)) { };
  guiSrcHash = "19kk1nc8h6ljczhizkgszw6xma31p0fmh6vkygpmrfwb8975d1s6";
  serverSrcHash = "1rs3l33jf33y02xri0b7chy02cjzd8v7l20ccjw2in8mw08mpc99";
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
