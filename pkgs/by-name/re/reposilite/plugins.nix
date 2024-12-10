{
  generateSplicesForMkScope,
  makeScopeWithSplicing',
}:
makeScopeWithSplicing' {
  otherSplices = generateSplicesForMkScope;
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
      checksum = "sha256-ocvjjcrZW8I7hMdWiUn36XEbx3TqNYi0okemo9zWelA=";
      groovy = "sha256-2NSTaivUAUMnAPHNqTNHWGqA8AF8jU9CE2ab9VGIFLo=";
      migration = "sha256-+BfbLEy2gc81HVCyI2JREIIYMirKwPV48shMBAMbWlU=";
      prometheus = "sha256-aukYUIS6S37ut9h+gO/JLrBUX/6RND5BhLqsrArxSUo=";
      swagger = "sha256-zD2ihVEfQeH3S1df3o2gF19kGIODW2yIRWCGbk4npJY=";
    };
}
