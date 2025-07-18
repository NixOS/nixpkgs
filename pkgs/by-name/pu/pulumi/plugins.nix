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
    pulumiTestHook = ./extra/pulumi-test-hook.sh;
  };
  f =
    self:
    lib.packagesFromDirectoryRecursive {
      inherit (self) callPackage;
      directory = ./plugins;
    }
    // lib.optionalAttrs config.allowAliases {
      pulumi-language-go = lib.warnOnInstantiate "pulumi-language-go has been renamed to pulumi-go" self.pulumi-go;
      pulumi-language-nodejs = lib.warnOnInstantiate "pulumi-language-nodejs has been renamed to pulumi-nodejs" self.pulumi-nodejs;
      pulumi-language-python = lib.warnOnInstantiate "pulumi-language-python has been renamed to pulumi-python" self.pulumi-python;
    };
}
