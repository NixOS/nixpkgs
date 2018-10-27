{ config, pkgs, stdenv, lib, ... }:

with lib;
{

  options = {
    runit.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable the runit init system.";
    };

    runit.package = mkOption {
      type = types.package;
      default = pkgs.runit;
      description = "Runit package.";
    };
  };

  config = mkIf config.runit.enable {
    environment.systemPackages = [ config.runit.package ];
  };

}
