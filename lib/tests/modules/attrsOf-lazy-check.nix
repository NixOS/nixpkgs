{ lib, config, ... }:
{
  options.isLazy = lib.mkOption {
    default = !config.value ? foo;
  };

  config.value.bar = throw "is not lazy";
}
