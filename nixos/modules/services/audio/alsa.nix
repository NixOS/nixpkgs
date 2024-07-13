# ALSA sound support.
{ config, lib, pkgs, ... }:

with lib;

{
  imports = [
    (mkRemovedOptionModule [ "sound" ] "The option was heavily overloaded and can be removed from most configurations.")
  ];

  options.hardware.alsa.enablePersistence = mkOption {
    type = types.bool;
    default = false;
    description = ''
      Whether to enable ALSA sound card state saving on shutdown.
      This is generally not necessary if you're using an external sound server.
    '';
  };

  config = mkIf config.hardware.alsa.enablePersistence {
    # ALSA provides a udev rule for restoring volume settings.
    services.udev.packages = [ alsa-utils ];

    systemd.services.alsa-store = {
      description = "Store Sound Card State";
      wantedBy = [ "multi-user.target" ];
      unitConfig = {
        RequiresMountsFor = "/var/lib/alsa";
        ConditionVirtualization = "!systemd-nspawn";
      };
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /var/lib/alsa";
        ExecStart = "${alsa-utils}/sbin/alsactl restore --ignore";
        ExecStop = "${alsa-utils}/sbin/alsactl store --ignore";
      };
    };
  };
}
