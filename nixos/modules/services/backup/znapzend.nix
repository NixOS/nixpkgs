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

        path = with pkgs; [ zfs mbuffer openssh ];

        serviceConfig = {
          ExecStart = "${pkgs.znapzend}/bin/znapzend";
          ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        };
      };
    };

  };
}
