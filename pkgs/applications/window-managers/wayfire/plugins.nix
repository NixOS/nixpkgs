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
  }
)
// lib.optionalAttrs config.allowAliases {
  firedecor = throw "wayfirePlugins.firedecor has been removed as it is unmaintained and no longer used by mate-wayland-session."; # Added 2025-09-03
  focus-request = throw "wayfirePlugins.focus-request is now included with wayfirePlugins.wayfire-plugins-extra"; # Added 2025-11-09
  wayfire-shadows = throw "wayfirePlugins.wayfire-shadows is now included with wayfirePlugins.wayfire-plugins-extra"; # Added 2025-11-09
  windecor = throw "wayfirePlugins.windecor has been removed as it is unmaintained"; # Added 2025-11-09
  wwp-switcher = throw "wayfirePlugins.wwp-switcher has been removed as it is unmaintained"; # Added 2025-11-09
}
