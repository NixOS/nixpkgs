{ callPackage }: builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  signal-desktop = {
    dir = "Signal";
    version = "6.16.0";
    hash = "sha256-q7z7TS16RORPbEMJBEmF3m2q4IdD3dM1xqv1DfgM9Zs=";
  };
  signal-desktop-beta = {
    dir = "Signal Beta";
    version = "6.17.0-beta.1";
    hash = "sha256-8Ae+IrwDRxcF5JhrDqEhimQqyCtDYWm/pOrcpKgAo2w=";
  };
}
