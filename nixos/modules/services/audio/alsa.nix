# ALSA sound support.
{ config, lib, pkgs, ... }:

{
  imports = [
    (lib.mkRemovedOptionModule [ "sound" ] "The option was heavily overloaded and can be removed from most configurations.")
  ];

  options.hardware.alsa.enablePersistence = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = ''
      Whether to enable ALSA sound card state saving on shutdown.
      This is generally not necessary if you're using an external sound server.
    '';
  };

  config = lib.mkIf config.hardware.alsa.enablePersistence {
    # ALSA provides a udev rule for restoring volume settings.
    services.udev.packages = [ pkgs.alsa-utils ];

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
        ExecStart = "${pkgs.alsa-utils}/sbin/alsactl restore --ignore";
        ExecStop = "${pkgs.alsa-utils}/sbin/alsactl store --ignore";
      };
    };
  };
}
