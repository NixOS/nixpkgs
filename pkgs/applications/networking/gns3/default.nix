{ callPackage, stdenv }:

let
  stableVersion = "2.1.19";
  previewVersion = "2.2.0b1";
  addVersion = args:
    let version = if args.stable then stableVersion else previewVersion;
        branch = if args.stable then "stable" else "preview";
    in args // { inherit version branch; };
  mkGui = args: callPackage (import ./gui.nix (addVersion args)) { };
  mkServer = args: callPackage (import ./server.nix (addVersion args)) { };
  guiSrcHash = "0bn0qry0djw17zwa16cc69273crnfzppik07f9w20hhr8kjiyvnx";
  serverSrcHash = "1af6pnmr24syx23pqvwchgwy74263k3ccrv7barxi71wsskjlw5a";
in {
  guiStable = mkGui {
    stable = true;
    sha256Hash = guiSrcHash;
  };
  guiPreview = mkGui {
    stable = false;
    sha256Hash = "0kx68r8kgnsb7710a1a5y64blmw2jl1gv37bzbbivi15dzgmykfh";
  };

  serverStable = mkServer {
    stable = true;
    sha256Hash = serverSrcHash;
  };
  serverPreview = mkServer {
    stable = false;
    sha256Hash = "1jxkba7hc7271hjw3839r0yfzs87dzv1nqx62adhk9qrrcfqhg58";
  };
}
