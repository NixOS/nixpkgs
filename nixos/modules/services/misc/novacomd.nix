{ config, lib, pkgs, ... }:
let

  cfg = config.services.novacomd;

in {

  options = {
    services.novacomd = {
      enable = lib.mkEnableOption "Novacom service for connecting to WebOS devices";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.webos.novacom ];

    systemd.services.novacomd = {
      description = "Novacom WebOS daemon";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${pkgs.webos.novacomd}/sbin/novacomd";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ dtzWill ];
}
