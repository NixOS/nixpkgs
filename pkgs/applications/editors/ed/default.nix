{ lib, pkgs }:

lib.makeScope pkgs.newScope (self:
  let
    inherit (self) callPackage;
  in {
    sources = import ./sources.nix {
      inherit lib;
      inherit (pkgs) fetchurl;
    };

    ed = callPackage (self.sources.ed) { };
    edUnstable = callPackage (self.sources.edUnstable) { };
  })
