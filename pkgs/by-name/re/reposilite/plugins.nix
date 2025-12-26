{
  lib,
  generateSplicesForMkScope,
  makeScopeWithSplicing',
}:
let
  pluginHashes = lib.importJSON ./plugins.json;
in
makeScopeWithSplicing' {
  otherSplices = generateSplicesForMkScope "reposilitePlugins";
  f =
    self:
    {
      fetchPlugin = self.callPackage (
        {
          lib,
          fetchurl,
          reposilite,
        }:
        lib.makeOverridable (
          { name, hash }:
          let
            inherit (reposilite) version;

            fancyName = lib.concatStrings [
              (lib.toUpper (builtins.substring 0 1 name))
              (builtins.substring 1 ((builtins.stringLength name) - 1) name)
            ];
          in
          fetchurl {
            url = "https://maven.reposilite.com/releases/com/reposilite/plugin/${name}-plugin/${version}/${name}-plugin-${version}-all.jar";
            inherit version hash;

            meta = {
              description = "${fancyName} plugin for Reposilite.";
              homepage = "https://github.com/dzikoysk/reposilite";
              sourceProvenance = with lib.sourceTypes; [ binaryBytecode ];
              license = lib.licenses.asl20;
              maintainers = with lib.maintainers; [ uku3lig ];
              inherit (reposilite.meta) platforms;
            };
          }
        )
      ) { };
    }
    // builtins.mapAttrs (name: hash: self.fetchPlugin { inherit name hash; }) pluginHashes;
}
