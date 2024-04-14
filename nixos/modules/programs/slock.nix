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
      package = mkPackageOption pkgs "slock" {};
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    security.wrappers.slock =
      { setuid = true;
        owner = "root";
        group = "root";
        source = lib.getExe cfg.package;
      };
  };
}
