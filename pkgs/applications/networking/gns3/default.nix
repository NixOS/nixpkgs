{ callPackage, stdenv }:

let
  stableVersion = "2.0.3";
  previewVersion = "2.1.0rc4";
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
    sha256Hash = "10p8i45n6qsf431d0xpy5dk3g5qh6zdlnfj82jn9xdyccgxs4x3s";
  };

  serverStable = mkServer {
    stable = true;
    sha256Hash = "1c7mzj1r2zh90a7vs3s17jakfp9s43b8nnj29rpamqxvl3qhbdy7";
  };
  serverPreview = mkServer {
    stable = false;
    sha256Hash = "1z8a3s90k86vmi4rwsd3v74gwvml68ci6f3zgxaji3z1sm22zcyd";
  };
}
