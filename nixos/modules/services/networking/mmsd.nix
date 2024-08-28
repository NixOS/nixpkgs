{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.services.mmsd;
  dbusServiceFile = pkgs.writeTextDir "share/dbus-1/services/org.ofono.mms.service" ''
    [D-BUS Service]
    Name=org.ofono.mms
    SystemdService=dbus-org.ofono.mms.service

    # Exec= is still required despite SystemdService= being used:
    # https://github.com/freedesktop/dbus/blob/ef55a3db0d8f17848f8a579092fb05900cc076f5/test/data/systemd-activation/com.example.SystemdActivatable1.service
    Exec=${pkgs.coreutils}/bin/false mmsd
  '';
in
{
  options.services.mmsd = {
    enable = lib.mkEnableOption "Multimedia Messaging Service Daemon";
    extraArgs = lib.mkOption {
      type = with lib.types; listOf str;
      description = "Extra arguments passed to `mmsd-tng`";
      default = [ ];
      example = [ "--debug" ];
    };
  };
  config = lib.mkIf cfg.enable {
    services.dbus.packages = [ dbusServiceFile ];
    systemd.user.services.mmsd = {
      after = [ "ModemManager.service" ];
      aliases = [ "dbus-org.ofono.mms.service" ];
      serviceConfig = {
        Type = "dbus";
        ExecStart = "${pkgs.mmsd-tng}/bin/mmsdtng " + lib.escapeShellArgs cfg.extraArgs;
        BusName = "org.ofono.mms";
        Restart = "on-failure";
      };
    };
  };
}
