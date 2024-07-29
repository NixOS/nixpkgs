# Compatibility shim
let
  lib = import ../../../lib;
  inherit (lib) mapAttrs;
  everything = import ./amazon-ec2-amis.nix;
  doAllVersions = mapAttrs (versionName: doRegion);
  doRegion = mapAttrs (regionName: systems: systems.x86_64-linux);
in
  doAllVersions everything
