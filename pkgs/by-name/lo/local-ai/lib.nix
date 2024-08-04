{ lib
, writers
, writeText
, linkFarmFromDrvs
}: {
  genModels = configs:
    let
      name = lib.strings.sanitizeDerivationName
        (builtins.concatStringsSep "_" ([ "local-ai-models" ] ++ (builtins.attrNames configs)));

      genModelFiles = name: config:
        let
          templateName = type: name + "_" + type;

          config' = lib.recursiveUpdate config ({
            inherit name;
          } // lib.optionalAttrs (lib.isDerivation config.parameters.model) {
            parameters.model = config.parameters.model.name;
          } // lib.optionalAttrs (config ? template) {
            template = builtins.mapAttrs (n: _: templateName n) config.template;
          });
        in
        [ (writers.writeYAML "${name}.yaml" config') ]
        ++ lib.optional (lib.isDerivation config.parameters.model)
          config.parameters.model
        ++ lib.optionals (config ? template)
          (lib.mapAttrsToList (n: writeText "${templateName n}.tmpl") config.template);
    in
    linkFarmFromDrvs name (lib.flatten (lib.mapAttrsToList genModelFiles configs));
}
