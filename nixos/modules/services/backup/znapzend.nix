{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.znapzend;
in
{
  options = {
    services.znapzend = {
      enable = mkEnableOption "ZnapZend daemon";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.znapzend ];

    systemd.services = {
      "znapzend" = {
        description = "ZnapZend - ZFS Backup System";
        after       = [ "zfs.target" ];

        path = with pkgs; [ znapzend zfs mbuffer openssh ];

        script = ''
          znapzend
        '';

        reload = ''
          /bin/kill -HUP $MAINPID
        '';
      };
    };

  };
}
