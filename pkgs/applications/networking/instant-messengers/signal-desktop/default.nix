{ callPackage }: builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  signal-desktop = {
    dir = "Signal";
    version = "6.9.0";
    hash = "sha256-VgEGFt8LvVpIWiqFyYiTXUavYY0YmnJ+CxrNhPP0hCg=";
  };
  signal-desktop-beta = {
    dir = "Signal Beta";
    version = "6.10.0-beta.1";
    hash = "sha256-A8jpYDWiCCBadRDzmNVxzucKPomgXlqdyeGiYp+1Byo=";
  };
}
