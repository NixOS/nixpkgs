{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  options.configuration = mkOption {
    description = "Additional configuration to be passed to the test";
    default = { };
    type = types.attrsOf (
      types.submodule (
          { name, ... }:
          {
            options.configuration = mkOption {
              type = types.raw;
              description = "Configuration expr be passed to test";
              default = { };
            };
          }
        )
      );
  };
}

