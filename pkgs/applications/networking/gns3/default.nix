{ callPackage, stdenv }:

let
  stableVersion = "2.0.3";
  previewVersion = "2.1.0rc1";
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
    sha256Hash = "0rmvanzc0fjw9giqwnf98yc49cxaz637w8b865dv08lcf1fg9j8l";
  };

  serverStable = mkServer {
    stable = true;
    sha256Hash = "1c7mzj1r2zh90a7vs3s17jakfp9s43b8nnj29rpamqxvl3qhbdy7";
  };
  serverPreview = mkServer {
    stable = false;
    sha256Hash = "181689fpjxq4hy2lyxk4zciqhgnhj5srvb4xsxdlbf68n89fj2zf";
  };
}
