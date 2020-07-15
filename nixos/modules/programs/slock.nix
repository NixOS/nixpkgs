{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.slock;

in
{
  options = {
    programs.slock = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Whether to install slock screen locker with setuid wrapper.
        '';
      };
      package = mkOption {
        type = types.package;
        default = pkgs.slock;
        defaultText = "pkgs.slock";
        description = ''
          slock package to use.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    security.wrappers.slock.source = "${cfg.package}/bin/slock";
  };
}
