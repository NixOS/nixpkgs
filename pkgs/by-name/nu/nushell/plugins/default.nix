{
  lib,
  config,
  callPackage,
  dbus,
}:
{
  bson = callPackage ./bson/package.nix { };
  dbus = callPackage ./dbus/package.nix { inherit dbus; };
  desktop_notifications = callPackage ./desktop_notifications/package.nix { };
  formats = callPackage ./formats/package.nix { };
  gstat = callPackage ./gstat/package.nix { };
  hcl = callPackage ./hcl/package.nix { };
  highlight = callPackage ./highlight/package.nix { };
  net = callPackage ./net/package.nix { };
  polars = callPackage ./polars/package.nix { };
  query = callPackage ./query/package.nix { };
  skim = callPackage ./skim/package.nix { };
  units = callPackage ./units/package.nix { };
}
// lib.optionalAttrs config.allowAliases {
  semver = throw "nushellPlugins.semver is EOL as starting with 0.114.0, nushell natively supports semver values."; # Added 2026-08-27
}
