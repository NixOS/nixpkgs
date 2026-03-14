{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.slock;

in
{
  options = {
    programs.slock = {
      enable = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether to install slock screen locker with setuid wrapper.
        '';
      };
      package = lib.mkPackageOption pkgs "slock" { };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    security.wrappers.slock = {
      setuid = true;
      owner = "root";
      group = "root";
      source = lib.getExe cfg.package;
    };
  };
}
