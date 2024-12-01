{
  config,
  lib,
  pkgs,
  extendModules,
  ...
}:
let
  inherit (lib) types;

  imageModules = { };
  imageConfigs = lib.mapAttrs (
    name: modules:
    extendModules {
      inherit modules;
    }
  ) config.image.modules;
in
{
  options = {
    system.build = {
      images = lib.mkOption {
        type = types.lazyAttrsOf types.raw;
        readOnly = true;
        description = ''
          Different target images generated for this NixOS configuration.
        '';
      };
    };
    image.modules = lib.mkOption {
      type = types.attrsOf (types.listOf types.deferredModule);
      description = ''
        image-specific NixOS Modules used for `system.build.images`.
      '';
    };
  };

  config.image.modules = lib.mkIf (!config.system.build ? image) imageModules;
  config.system.build.images = lib.mkIf (!config.system.build ? image) (
    lib.mapAttrs (
      name: nixos:
      let
        inherit (nixos) config;
        inherit (config.image) filePath;
        builder =
          config.system.build.image
            or (throw "Module for `system.build.images.${name}` misses required `system.build.image` option.");
      in
      lib.recursiveUpdate builder {
        passthru = {
          inherit config filePath;
        };
      }
    ) imageConfigs
  );
}
