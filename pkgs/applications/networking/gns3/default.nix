{ callPackage, stdenv }:

let
  stableVersion = "2.1.14";
  previewVersion = "2.2.0a2";
  addVersion = args:
    let version = if args.stable then stableVersion else previewVersion;
        branch = if args.stable then "stable" else "preview";
    in args // { inherit version branch; };
  mkGui = args: callPackage (import ./gui.nix (addVersion args)) { };
  mkServer = args: callPackage (import ./server.nix (addVersion args)) { };
  guiSrcHash = "1k4g1sd9s6nc3rsc918chnkr515qik4hfd4z5lw065bp3lshf48b";
  serverSrcHash = "0npm9p52jk04g9cmflsfph4dkj6373mfyvd3hff1caqmjalnfxg4";
in {
  guiStable = mkGui {
    stable = true;
    sha256Hash = guiSrcHash;
  };
  guiPreview = mkGui {
    stable = false;
    sha256Hash = "1lvdff4yfavfkjmdbhxqfxdd5nq77c2vyy2wnsdliwnmdh3fhm28";
  };

  serverStable = mkServer {
    stable = true;
    sha256Hash = serverSrcHash;
  };
  serverPreview = mkServer {
    stable = false;
    sha256Hash = "033bi1bcw5ss6g380qnam1qqyi4bz1cykbb3lparb8hryikicdb9";
  };
}
