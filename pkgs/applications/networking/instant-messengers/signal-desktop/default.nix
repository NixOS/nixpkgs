{ callPackage }: builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  signal-desktop = {
    dir = "Signal";
    version = "6.14.0";
    hash = "sha256-dy/qzOv3x+nv3tIwHJUQ2BIwUNsvGbsKZOZxkgD3270=";
  };
  signal-desktop-beta = {
    dir = "Signal Beta";
    version = "6.15.0-beta.1";
    hash = "sha256-aeJGwBoAs6iDpVjBzlcs7q9Jvn/h3KLcCV3m1yjMTNQ=";
  };
}
