{ callPackage }: builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  signal-desktop = {
    dir = "Signal";
    version = "6.37.0";
    hash = "sha256-oPW2YHyYsbTvQ+8VQtaubBki7w2wd1tlgVmPL5v5E5s=";
  };
  signal-desktop-beta = {
    dir = "Signal Beta";
    version = "6.38.0-beta.1";
    hash = "sha256-DZXqq4AD1arP+o5xbuR8yD5By5VPBtClchScZb2Nb1U=";
  };
}
