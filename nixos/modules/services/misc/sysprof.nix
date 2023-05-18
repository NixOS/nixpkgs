{ config, lib, pkgs, ... }:

{
  options = {
    services.sysprof = {
      enable = lib.mkEnableOption (lib.mdDoc "sysprof profiling daemon");
    };
  };

  config = lib.mkIf config.services.sysprof.enable {
    environment.systemPackages = [ pkgs.sysprof ];

    services.dbus.packages = [ pkgs.sysprof ];

    systemd.packages = [ pkgs.sysprof ];
  };

  meta.maintainers = pkgs.sysprof.meta.maintainers;
}
