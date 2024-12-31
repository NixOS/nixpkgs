{ lib, pkgs }:

lib.makeScope pkgs.newScope (
  self:
  let
    inherit (self) callPackage;
  in
  {
    firedecor = callPackage ./firedecor.nix { };
    focus-request = callPackage ./focus-request.nix { };
    wayfire-plugins-extra = callPackage ./wayfire-plugins-extra.nix { };
    wayfire-shadows = callPackage ./wayfire-shadows.nix { };
    wcm = callPackage ./wcm.nix { };
    wf-shell = callPackage ./wf-shell.nix { };
    windecor = callPackage ./windecor.nix { };
    wwp-switcher = callPackage ./wwp-switcher.nix { };
  }
)
