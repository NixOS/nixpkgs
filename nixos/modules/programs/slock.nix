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
        description = lib.mdDoc ''
          Whether to install slock screen locker with setuid wrapper.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.slock ];
    security.wrappers.slock =
      { setuid = true;
        owner = "root";
        group = "root";
        source = "${pkgs.slock.out}/bin/slock";
      };
  };
}
