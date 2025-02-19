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
    testResourceSchema = self.callPackage ./extra/test-resource-schema.nix { };
  };
  f =
    self:
    lib.packagesFromDirectoryRecursive {
      inherit (self) callPackage;
      directory = ./plugins;
    }
    // lib.optionalAttrs config.allowAliases {
      # TODO: perhaps use lib.warnOnInstantiate?
      pulumi-language-go = self.pulumi-go;
      pulumi-language-nodejs = self.pulumi-nodejs;
      pulumi-language-python = self.pulumi-python;
    };

}
