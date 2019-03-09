{ callPackage, stdenv }:

let
  stableVersion = "2.1.14";
  previewVersion = "2.2.0a1";
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
    sha256Hash = "16jjgfbdi7b3349wrqalf40qcaqzw3d4vdjbwcy8dbqblg48hn5w";
  };

  serverStable = mkServer {
    stable = true;
    sha256Hash = serverSrcHash;
  };
  serverPreview = mkServer {
    stable = false;
    sha256Hash = "0bcsjljy947grfn3y9xyi3dbzdw5wkljq1nr66cqfkidx9f4fzni";
  };
}
