{
  generateSplicesForMkScope,
  makeScopeWithSplicing',
}:
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
    // builtins.mapAttrs (name: hash: self.fetchPlugin { inherit name hash; }) {
      checksum = "sha256-k9JWyDj7wMB8kLihqR7gB5N//NKxTrDWoFQ4Jt422I0=";
      groovy = "sha256-iwlLMHh9A6WIHYo4sN2TIISif9pWbe6i1Hofd4D3BsI=";
      migration = "sha256-0p4DQeaCH/i2e8MESPIbOgaSPF0pHIbs1rXiZcSCJso=";
      prometheus = "sha256-bCJvTQPXW3mydOqz5Tug6MyIEonrRiJ9NkIYy9OviDc=";
      swagger = "sha256-akKRMibzA4UtGpwcHvmjXKPLzpA2pcGPpaBkDsdvcK0=";
    };
}
