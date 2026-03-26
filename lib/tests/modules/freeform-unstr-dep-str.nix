{ lib, config, ... }:
{
  options.value = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
  };

  config.foo = lib.mkIf (config.value != null) config.value;
}
