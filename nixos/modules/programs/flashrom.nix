{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.flashrom;
in
{
  options.programs.flashrom = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Installs flashrom and configures udev rules for programmers
        used by flashrom. Grants access to users in the "flashrom"
        group.
      '';
    };
  };

  config = mkIf cfg.enable {
    services.udev.packages = [ pkgs.flashrom ];
    environment.systemPackages = [ pkgs.flashrom ];
    users.groups.flashrom = { };
  };
}
