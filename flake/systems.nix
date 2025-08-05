{ lib, ... }:
{
  options.systems = lib.mkOption {
    type = lib.types.listOf lib.types.str;
  };
  config.systems = lib.systems.flakeExposed;
}
