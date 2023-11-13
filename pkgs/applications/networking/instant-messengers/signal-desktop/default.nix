{ callPackage }: builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  signal-desktop = {
    dir = "Signal";
    version = "6.38.0";
    hash = "sha256-y2mwO7Qc01vuIeJUcAxYDD97DXOwXCd8wNZmkG4maF0=";
  };
  signal-desktop-beta = {
    dir = "Signal Beta";
    version = "6.39.0-beta.2";
    hash = "sha256-1+1wvkMtEovBBs2bS9zUV5kpSxkPy0EqBAU01el8uko=";
  };
}
