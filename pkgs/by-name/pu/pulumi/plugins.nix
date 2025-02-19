{
  lib,
  config,
  generateSplicesForMkScope,
  makeScopeWithSplicing',
  attributePathToSplice ? [ "pulumiPackages" ],
}:
makeScopeWithSplicing' {
  otherSplices = generateSplicesForMkScope attributePathToSplice;
  extra = self: {
    mkPulumiPackage = self.callPackage ./extra/mk-pulumi-package.nix { };
  };
  f =
    self:
    lib.packagesFromDirectoryRecursive {
      inherit (self) callPackage;
      directory = ./plugins;
    };
}
