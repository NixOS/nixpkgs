{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.tzupdate;
in {
  options.services.tzupdate = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Enable the tzupdate timezone updating service. This provides
        a one-shot service which can be activated with systemctl to
        update the timezone.
      '';
    };
  };

  config = mkIf cfg.enable {
    # We need to have imperative time zone management for this to work.
    # This will give users an error if they have set an explicit time
    # zone, which is better than silently overriding it.
    time.timeZone = null;

    # We provide a one-shot service which can be manually run. We could
    # provide a service that runs on startup, but it's tricky to get
    # a service to run after you have *internet* access.
    systemd.services.tzupdate = {
      description = "tzupdate timezone update service";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];

      serviceConfig = {
        Type = "oneshot";
        # We could link directly into pkgs.tzdata, but at least timedatectl seems
        # to expect the symlink to point directly to a file in etc.
        # Setting the "debian timezone file" to point at /dev/null stops it doing anything.
        ExecStart = "${pkgs.tzupdate}/bin/tzupdate -z /etc/zoneinfo -d /dev/null";
      };
    };
  };

  meta.maintainers = [ maintainers.michaelpj ];
}
