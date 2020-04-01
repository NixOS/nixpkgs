{ callPackage }:

let
  stableVersion = "2.2.6";
  previewVersion = stableVersion;
  addVersion = args:
    let version = if args.stable then stableVersion else previewVersion;
        branch = if args.stable then "stable" else "preview";
    in args // { inherit version branch; };
  extraArgs = rec {
    mkOverride = attrname: version: sha256:
      self: super: {
        ${attrname} = super.${attrname}.overridePythonAttrs (oldAttrs: {
          inherit version;
          src = oldAttrs.src.override {
            inherit version sha256;
          };
          doCheck = oldAttrs.doCheck && (attrname != "psutil");
        });
      };
    commonOverrides = [
      (mkOverride "psutil" "5.6.6"
        "1rs6z8bfy6bqzw88s4i5zllrx3i18hnkv4akvmw7bifngcgjh8dd")
    ];
  };
  mkGui = args: callPackage (import ./gui.nix (addVersion args // extraArgs)) { };
  mkServer = args: callPackage (import ./server.nix (addVersion args // extraArgs)) { };
  guiSrcHash = "0inqy2zw5h9cgiyqb04kv8b5sjrdi4a637gdqs83k887axkd48aw";
  serverSrcHash = "04d9lny5vyk0kbi5ilv5mngaicnxb077xpcaaqlcd9b1m3kiq19n";
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
