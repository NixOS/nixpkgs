{ callPackage }: builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  signal-desktop = {
    dir = "Signal";
    version = "6.2.0";
    hash = "sha256-auOcMlwKPj5rsnlhK34sYe4JxlHCjb3e2ye8Cs12Qtc=";
  };
  signal-desktop-beta = {
    dir = "Signal Beta";
    ringrtcPrefix = "@signalapp/";
    version = "6.3.0-beta.1";
    hash = "sha256-cYJWhnyiWULnIZvI2/k1koLCd2zrL4CVMohcnSZa/TY=";
  };
}
