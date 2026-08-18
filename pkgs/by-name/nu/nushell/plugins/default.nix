{
  callPackage,
  dbus,
}:
{
  bson = callPackage ./bson/package.nix;
  dbus = callPackage ./dbus/package.nix { inherit dbus; };
  desktop_notifications = callPackage ./desktop_notifications/package.nix { };
  formats = callPackage ./formats/package.nix { };
  gstat = callPackage ./gstat/package.nix { };
  hcl = callPackage ./hcl/package.nix { };
  highlight = callPackage ./highlight/package.nix { };
  net = callPackage ./net/package.nix { };
  polars = callPackage ./polars/package.nix { };
  query = callPackage ./query/package.nix { };
  semver = callPackage ./semver/package.nix { };
  skim = callPackage ./skim/package.nix { };
  units = callPackage ./units/package.nix { };
}
