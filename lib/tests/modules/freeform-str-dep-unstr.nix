{ lib, config, ... }: {
  options.foo = lib.mkOption {
    type = lib.types.nullOr lib.types.str;
    default = null;
  };

  config.foo = lib.mkIf (config ? value) config.value;
}
