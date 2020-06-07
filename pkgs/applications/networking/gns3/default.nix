{ callPackage }:

let
  stableVersion = "2.2.9";
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
  guiSrcHash = "0xbkzd43zzy1xlwwz7jvjjq21iqy6b08pbs37r6g8jciwiyqrcbd";
  serverSrcHash = "1jaap1sxkh4yivrp8z0izypl9n6ss4540n22xkf5fnkv91k0mr5n";
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
