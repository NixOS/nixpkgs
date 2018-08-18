{ callPackage, stdenv }:

let
  stableVersion = "2.1.7";
  # Currently there is no preview version.
  previewVersion = stableVersion;
  addVersion = args:
    let version = if args.stable then stableVersion else previewVersion;
        branch = if args.stable then "stable" else "preview";
    in args // { inherit version branch; };
  mkGui = args: callPackage (import ./gui.nix (addVersion args)) { };
  mkServer = args: callPackage (import ./server.nix (addVersion args)) { };
  guiSrcHash = "10zf429zjzf7v4y9r7mmkp42kh5ppmqinhvwqzb7jmsrpv2cnxj6";
  serverSrcHash = "056swz6ygqdi37asah51v1yy0ky8q0p32vf7dxs697hd7nv78aqj";
in {
  guiStable = mkGui {
    stable = true;
    sha256Hash = guiSrcHash;
  };
  guiPreview = mkGui {
    stable = false;
    sha256Hash = guiSrcHash;
  };

  serverStable = mkServer {
    stable = true;
    sha256Hash = serverSrcHash;
  };
  serverPreview = mkServer {
    stable = false;
    sha256Hash = serverSrcHash;
  };
}
