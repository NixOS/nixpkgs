{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.configuration = mkOption {
    description = "Additional configuration to be passed to the test";
    default = { };
    type = types.attrsOf (
      types.deferredModuleWith (
        staticModules = [
          { _class = "nixos"; }
          { name, ... }: {
            options.module = mkOption {
              type = types.path;
              description = "Configuration be passed to node";
            };
          }
        ];
      );
    );
  };
}

