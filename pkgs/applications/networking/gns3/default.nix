{ callPackage, stdenv }:

let
  stableVersion = "2.1.18";
  previewVersion = "2.2.0b1";
  addVersion = args:
    let version = if args.stable then stableVersion else previewVersion;
        branch = if args.stable then "stable" else "preview";
    in args // { inherit version branch; };
  mkGui = args: callPackage (import ./gui.nix (addVersion args)) { };
  mkServer = args: callPackage (import ./server.nix (addVersion args)) { };
  guiSrcHash = "00hcri32vakz17ywbqd9lycxdai490ds0g1v8znm75ddvszfbv7i";
  serverSrcHash = "0f28f5f4dsr8h4q592dh9i1z0gp836gdgm8clwrkb7i01df0rrlf";
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
