{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.adw-bluetooth;
in
{
  meta.maintainers = with lib.maintainers; [ ezratweaver ];

  options.services.adw-bluetooth = {
    enable = lib.mkEnableOption "Adwaita Bluetooth daemon";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.adw-bluetooth ];
    services.dbus.packages = [ pkgs.adw-bluetooth ];

    systemd.user.services.adw-bluetooth-daemon = {
      description = "AdwBluetooth Daemon";
      wantedBy = [ "default.target" ];
      after = [ "bluetooth.target" ];
      serviceConfig = {
        Type = "dbus";
        BusName = "com.ezratweaver.AdwBluetoothDaemon";
        ExecStart = "${pkgs.adw-bluetooth}/libexec/adw-bluetooth-daemon";
      };
    };
  };
}
