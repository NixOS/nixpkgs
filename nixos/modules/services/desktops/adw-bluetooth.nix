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
    package = lib.mkPackageOption pkgs "adw-bluetooth" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    services.dbus.packages = [ cfg.package ];

    systemd.user.services.adw-bluetooth-daemon = {
      description = "AdwBluetooth Daemon";
      wantedBy = [ "default.target" ];
      after = [ "bluetooth.target" ];
      serviceConfig = {
        Type = "dbus";
        BusName = "com.ezratweaver.AdwBluetoothDaemon";
        ExecStart = "${cfg.package}/libexec/adw-bluetooth-daemon";
      };
    };
  };
}
