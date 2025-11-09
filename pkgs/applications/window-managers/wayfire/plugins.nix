{
  config,
  lib,
  pkgs,
}:

lib.makeScope pkgs.newScope (
  self:
  let
    inherit (self) callPackage;
  in
  {
    wayfire-plugins-extra = callPackage ./wayfire-plugins-extra.nix { };
    wcm = callPackage ./wcm.nix { };
    wf-shell = callPackage ./wf-shell.nix { };
    windecor = callPackage ./windecor.nix { };
    wwp-switcher = callPackage ./wwp-switcher.nix { };
  }
)
// lib.optionalAttrs config.allowAliases {
  firedecor = throw "wayfirePlugins.firedecor has been removed as it is unmaintained and no longer used by mate-wayland-session."; # Added 2025-09-03
  focus-request = throw "wayfirePlugins.focus-request is now included with wayfirePlugins.wayfire-plugins-extra";
  wayfire-shadows = throw "wayfirePlugins.wayfire-shadows is now included with wayfirePlugins.wayfire-plugins-extra";
}
