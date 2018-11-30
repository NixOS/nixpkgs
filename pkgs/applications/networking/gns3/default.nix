{ callPackage, stdenv }:

let
  stableVersion = "2.1.11";
  # Currently there is no preview version.
  previewVersion = stableVersion;
  addVersion = args:
    let version = if args.stable then stableVersion else previewVersion;
        branch = if args.stable then "stable" else "preview";
    in args // { inherit version branch; };
  mkGui = args: callPackage (import ./gui.nix (addVersion args)) { };
  mkServer = args: callPackage (import ./server.nix (addVersion args)) { };
  guiSrcHash = "1skcb47r0wvv7l7z487b2165pwvc397b23abfq24kw79806vknzn";
  serverSrcHash = "09j2nafxvgc6plk7s3qwv5qc0cc2bi41h4fhg8g7c85ixfx5yz8a";
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
