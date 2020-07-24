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
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.slock ];
    security.wrappers.slock.source = "${pkgs.slock.out}/bin/slock";
  };
}
