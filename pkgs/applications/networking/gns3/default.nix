{ callPackage, stdenv }:

let
  stableVersion = "2.1.13";
  previewVersion = "2.2.0a1";
  addVersion = args:
    let version = if args.stable then stableVersion else previewVersion;
        branch = if args.stable then "stable" else "preview";
    in args // { inherit version branch; };
  mkGui = args: callPackage (import ./gui.nix (addVersion args)) { };
  mkServer = args: callPackage (import ./server.nix (addVersion args)) { };
  guiSrcHash = "1hr651s6gqjy5shyy3ysk4fz4hs3p72wiqm4fbpgcs4hyxxd4fi8";
  serverSrcHash = "1dgy5s3dvg4mpyx1zn1qp6wf3vgkymj34ymx4pn1sak45ixij9kz";
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
