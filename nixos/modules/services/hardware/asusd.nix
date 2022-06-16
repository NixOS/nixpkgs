# asusd daemon.

{ config, lib, pkgs, ... }:
let
  cfg = config.services.asusd;
in
{
  options = {
    services.asusd = {
      enable = lib.mkEnableOption "ASUS Notebook Control";
      ledmodesFile = lib.mkOption {
        type = lib.types.str;
        default = "${pkgs.asusctl}/etc/asusd/asusd-ledmodes.toml";
        defaultText = "\${pkgs.asusctl}/etc/asusd/asusd-ledmodes.toml";
        description = "The ledmodes settings to be used by asusd";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.asusd = {
      description = "ASUS Notebook Control";
      before = [ "multi-user.target" ];
      startLimitIntervalSec = 200;
      startLimitBurst = 2;
      environment."IS_SERVICE" = "1";
      serviceConfig = {
        ExecStart = "${pkgs.asusctl}/bin/asusd";
        Restart = "on-failure";
        RestartSec = 1;
        Type = "dbus";
        BusName = "org.asuslinux.Daemon";
        SELinuxContext = "system_u:system_r:unconfined_t:s0";
      };
    };
    systemd.user.services.asus-notify = {
      description = "ASUS Notifications";
      wantedBy = [ "default.target" ];
      startLimitIntervalSec = 200;
      startLimitBurst = 2;
      serviceConfig = {
        ExecStart = "${pkgs.asusctl}/bin/asus-notify";
        Restart = "always";
        RestartSec = 1;
      };
    };
    services.dbus.packages = [ pkgs.asusctl ];
    environment.etc."asusd/asusd-ledmodes.toml".source = cfg.ledmodesFile;
  };

  meta.maintainers = with lib.maintainers; [ sauricat ];
}
