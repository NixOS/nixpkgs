{ callPackage }:

let
  stableVersion = "2.2.8";
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
  guiSrcHash = "1qgzad9hdbvkdalzdnlg5gnlzn2f9qlpd1aj8djmi6w1mmdkf9q7";
  serverSrcHash = "1kg38dh0xk4yvi7hz0d5dq9k0wany0sfd185l0zxs3nz78zd23an";
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
