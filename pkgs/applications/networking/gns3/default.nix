{ callPackage, stdenv }:

let
  stableVersion = "2.0.3";
  previewVersion = "2.1.0rc3";
  addVersion = args:
    let version = if args.stable then stableVersion else previewVersion;
        branch = if args.stable then "stable" else "preview";
    in args // { inherit version branch; };
  mkGui = args: callPackage (import ./gui.nix (addVersion args)) { };
  mkServer = args: callPackage (import ./server.nix (addVersion args)) { };
in {
  guiStable = mkGui {
    stable = true;
    sha256Hash = "10qp6430md8d0h2wamgfaq7pai59mqmcw6sw3i1gvb20m0avvsvb";
  };
  guiPreview = mkGui {
    stable = false;
    sha256Hash = "0yc5lr01xb7lk4dsrwx79mimbr91vldpvqbrx37j3kym6p5m84cn";
  };

  serverStable = mkServer {
    stable = true;
    sha256Hash = "1c7mzj1r2zh90a7vs3s17jakfp9s43b8nnj29rpamqxvl3qhbdy7";
  };
  serverPreview = mkServer {
    stable = false;
    sha256Hash = "1lac88d9cmlhrwmlvxv1sk86600rwznw3lpsm440bax6qbdfcis3";
  };
}
