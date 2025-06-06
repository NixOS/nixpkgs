{ pkgs, lib, config, ... }:
with lib;
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
    enable = mkEnableOption "Multimedia Messaging Service Daemon";
    extraArgs = mkOption {
      type = with types; listOf str;
      description = "Extra arguments passed to `mmsd-tng`";
      default = [];
      example = ["--debug"];
    };
  };
  config = mkIf cfg.enable {
    services.dbus.packages = [ dbusServiceFile ];
    systemd.user.services.mmsd = {
      after = [ "ModemManager.service" ];
      aliases = [ "dbus-org.ofono.mms.service" ];
      serviceConfig = {
        Type = "dbus";
        ExecStart = "${pkgs.mmsd-tng}/bin/mmsdtng " + escapeShellArgs cfg.extraArgs;
        BusName = "org.ofono.mms";
        Restart = "on-failure";
      };
    };
  };
}
