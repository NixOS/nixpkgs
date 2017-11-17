{ callPackage, stdenv }:

let
  stableVersion = "2.1.0";
  previewVersion = "2.1.0rc4"; # == 2.1.0
  addVersion = args:
    let version = if args.stable then stableVersion else previewVersion;
        branch = if args.stable then "stable" else "preview";
    in args // { inherit version branch; };
  mkGui = args: callPackage (import ./gui.nix (addVersion args)) { };
  mkServer = args: callPackage (import ./server.nix (addVersion args)) { };
in {
  guiStable = mkGui {
    stable = true;
    sha256Hash = "0fms8469daa8jhmsdqnadm18gc27g18q4m974wjfpz9n1rn78sjk";
  };
  guiPreview = mkGui {
    stable = false;
    sha256Hash = "10p8i45n6qsf431d0xpy5dk3g5qh6zdlnfj82jn9xdyccgxs4x3s";
  };

  serverStable = mkServer {
    stable = true;
    sha256Hash = "1s66qnkhd9rqak13m57i266bgrk8f1ky2wxdha1jj0q9gxdsqa39";
  };
  serverPreview = mkServer {
    stable = false;
    sha256Hash = "1z8a3s90k86vmi4rwsd3v74gwvml68ci6f3zgxaji3z1sm22zcyd";
  };
}
