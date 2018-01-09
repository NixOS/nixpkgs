{ callPackage, stdenv }:

let
  stableVersion = "2.1.2";
  previewVersion = "2.1.2";
  addVersion = args:
    let version = if args.stable then stableVersion else previewVersion;
        branch = if args.stable then "stable" else "preview";
    in args // { inherit version branch; };
  mkGui = args: callPackage (import ./gui.nix (addVersion args)) { };
  mkServer = args: callPackage (import ./server.nix (addVersion args)) { };
in {
  guiStable = mkGui {
    stable = true;
    sha256Hash = "1p3z1dlank0nzj5yyap2n2gv1xa66x9iqi4q7vvy0xcxbqzmqszk";
  };
  guiPreview = mkGui {
    stable = false;
    sha256Hash = "1p3z1dlank0nzj5yyap2n2gv1xa66x9iqi4q7vvy0xcxbqzmqszk";
  };

  serverStable = mkServer {
    stable = true;
    sha256Hash = "0nd7j33ns94hh65b9j0m177b7h25slpny74ga8qppghvv2iqsbp8";
  };
  serverPreview = mkServer {
    stable = false;
    sha256Hash = "0nd7j33ns94hh65b9j0m177b7h25slpny74ga8qppghvv2iqsbp8";
  };
}
