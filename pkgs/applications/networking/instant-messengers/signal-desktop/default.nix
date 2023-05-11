{ callPackage }: builtins.mapAttrs (pname: attrs: callPackage ./generic.nix (attrs // { inherit pname; })) {
  signal-desktop = {
    dir = "Signal";
    version = "6.17.0";
    hash = "sha256-CSyFkO06yeExZAQBKQNGIwc3KEFcpibm5UM3ij2k+G8=";
  };
  signal-desktop-beta = {
    dir = "Signal Beta";
    version = "6.17.0-beta.1";
    hash = "sha256-8Ae+IrwDRxcF5JhrDqEhimQqyCtDYWm/pOrcpKgAo2w=";
  };
}
