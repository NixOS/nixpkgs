{ lib, return }:
lib.getAttr return {
  mkPerSystemOption =
    {
      name,
      type,
    }:
    {
      config.perSystem.module = {
        options.${name} = lib.mkOption {
          type = lib.types.nullOr type;
          default = null;
        };
      };

      options.perSystem.applied.${name} = lib.mkOption {
        type = lib.types.lazyAttrsOf type;
        default = { };
      };
    };

  module =
    { lib, config, ... }:
    {
      options.perSystem.module = lib.mkOption {
        type = lib.types.deferredModule;
      };

      config.perSystem.applied = lib.pipe config.systems [
        (map (
          system:
          let
            perSystem = lib.evalModules {
              specialArgs = { inherit system; };
              modules = [ config.perSystem.module ];
            };
          in
          lib.pipe perSystem.config [
            (lib.filterAttrs (name: value: (value != null)))
            (lib.mapAttrs (name: value: { ${system} = value; }))
          ]
        ))
        lib.mkMerge
      ];
    };
}
