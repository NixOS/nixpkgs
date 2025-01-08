{ config, lib, ... }:
{
  options = {
    result = lib.mkOption {
      internal = true;
      default = config;
    };
  };
}
