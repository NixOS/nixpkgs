{
  lib,
  newScope,
}:
lib.makeScope newScope (
  self:
  let
    packages = lib.packagesFromDirectoryRecursive {
      inherit (self) callPackage;
      directory = ./plugins;
    };
  in
  {
    mkPackerPlugin = self.callPackage ./extra/mk-packer-plugin.nix { };
  }
  // lib.mapAttrs' (
    name: pkg: lib.nameValuePair (lib.removePrefix "packer-plugin-" name) pkg
  ) packages
)
