{ config, lib, pkgs, ... }:

with lib;

let

  inherit (pkgs) ntp;

  cfg = config.services.ntp;

  stateDir = "/var/lib/ntp";

  ntpUser = "ntp";

  configFile = pkgs.writeText "ntp.conf" ''
    driftfile ${stateDir}/ntp.drift

    restrict 127.0.0.1
    restrict -6 ::1

    ${toString (map (server: "server " + server + " iburst\n") cfg.servers)}
  '';

  ntpFlags = "-c ${configFile} -u ${ntpUser}:nogroup ${toString cfg.extraFlags}";

in

{

  ###### interface

  options = {

    services.ntp = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to synchronise your machine's time using the NTP
          protocol.
        '';
      };

      servers = mkOption {
        default = config.networking.timeServers;
        description = ''
          The set of NTP servers from which to synchronise.
        '';
      };

      extraFlags = mkOption {
        type = types.listOf types.str;
        description = "Extra flags passed to the ntpd command.";
        default = [];
      };

    };

  };


  ###### implementation

  config = mkIf config.services.ntp.enable {

    # Make tools such as ntpq available in the system path.
    environment.systemPackages = [ pkgs.ntp ];
    services.timesyncd.enable = mkForce false;

    systemd.services.systemd-timedated.environment = { SYSTEMD_TIMEDATED_NTP_SERVICES = "ntpd.service"; };

    users.users = singleton
      { name = ntpUser;
        uid = config.ids.uids.ntp;
        description = "NTP daemon user";
        home = stateDir;
      };

    systemd.services.ntpd =
      { description = "NTP Daemon";

        wantedBy = [ "multi-user.target" ];
        wants = [ "time-sync.target" ];
        before = [ "time-sync.target" ];

        preStart =
          ''
            mkdir -m 0755 -p ${stateDir}
            chown ${ntpUser} ${stateDir}
          '';

        serviceConfig = {
          ExecStart = "@${ntp}/bin/ntpd ntpd -g ${ntpFlags}";
          Type = "forking";
        };
      };

  };

}
