{ lib, ... }:
{
  options.value = lib.mkOption {
    type = lib.types.nestedAttrsOf (
      lib.types.submodule {
        options = {
          request = lib.mkOption {
            type = lib.types.int;
            default = 0;
          };
          result = lib.mkOption {
            type = lib.types.int;
            default = 0;
          };
        };
      }
    );
    default = { };
  };
  # Misshapen: scalar where an attrset `{ request = ...; result = ...; }` was expected.
  config.value.consumer = 1;
}
