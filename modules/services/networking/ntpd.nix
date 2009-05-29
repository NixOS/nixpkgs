{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption mkIf;

  options = {
    services = {
      ntp = {

        enable = mkOption {
          default = true;
          description = "
            Whether to synchronise your machine's time using the NTP
            protocol.
          ";
        };

        servers = mkOption {
          default = [
            "0.pool.ntp.org"
            "1.pool.ntp.org"
            "2.pool.ntp.org"
          ];
          description = "
            The set of NTP servers from which to synchronise.
          ";
        };

      };
    };
  };
in

###### implementation

let

  inherit (pkgs) writeText ntp;

  stateDir = "/var/lib/ntp";

  ntpUser = "ntp";

  servers = config.services.ntp.servers;

  modprobe = config.system.sbin.modprobe;

  configFile = writeText "ntp.conf" ''
    driftfile ${stateDir}/ntp.drift
    # Keep the drift file in ${stateDir}/ntp.drift.  However, since we
    # chroot to ${stateDir}, we have to specify it as /ntp.drift.
    driftfile /ntp.drift

    ${toString (map (server: "server " + server + "\n") servers)}
  '';

  ntpFlags = "-c ${configFile} -u ${ntpUser}:nogroup -i ${stateDir}";

in


mkIf config.services.ntp.enable {
  require = [
    options
  ];

  services = {
    extraJobs = [{

      name = "ntpd";
      
      users = [
        { name = ntpUser;
          uid = config.ids.uids.ntp;
          description = "NTP daemon user";
          home = stateDir;
        }
      ];
      
      job = ''
        description "NTP daemon"

        start on ip-up
        stop on ip-down
        stop on shutdown

        start script

            mkdir -m 0755 -p ${stateDir}
            chown ${ntpUser} ${stateDir}

            # Needed to run ntpd as an unprivileged user.
            ${modprobe}/sbin/modprobe capability || true

            ${ntp}/bin/ntpd -q -g ${ntpFlags}

        end script

        respawn ${ntp}/bin/ntpd -n ${ntpFlags}
      '';
    }];
  };
}
