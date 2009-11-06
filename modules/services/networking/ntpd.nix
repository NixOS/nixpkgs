{ config, pkgs, ... }:

with pkgs.lib;

let

  inherit (pkgs) ntp;

  stateDir = "/var/lib/ntp";

  ntpUser = "ntp";

  servers = config.services.ntp.servers;

  modprobe = config.system.sbin.modprobe;

  configFile = pkgs.writeText "ntp.conf" ''
    driftfile ${stateDir}/ntp.drift
    # Keep the drift file in ${stateDir}/ntp.drift.  However, since we
    # chroot to ${stateDir}, we have to specify it as /ntp.drift.
    driftfile /ntp.drift

    ${toString (map (server: "server " + server + "\n") servers)}
  '';

  ntpFlags = "-c ${configFile} -u ${ntpUser}:nogroup -i ${stateDir}";

in

{

  ###### interface
  
  options = {
  
    services.ntp = {

      enable = mkOption {
        default = true;
        description = ''
          Whether to synchronise your machine's time using the NTP
          protocol.
        '';
      };

      servers = mkOption {
        default = [
          "0.pool.ntp.org"
          "1.pool.ntp.org"
          "2.pool.ntp.org"
        ];
        description = ''
          The set of NTP servers from which to synchronise.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.ntp.enable {
  
    users.extraUsers = singleton
      { name = ntpUser;
        uid = config.ids.uids.ntp;
        description = "NTP daemon user";
        home = stateDir;
      };

    jobs.ntpd =
      { description = "NTP daemon";

        startOn = "ip-up";
        stopOn = "ip-down";

        preStart =
          ''
            mkdir -m 0755 -p ${stateDir}
            chown ${ntpUser} ${stateDir}

            # Needed to run ntpd as an unprivileged user.
            ${modprobe}/sbin/modprobe --quiet capability

            # !!! This can hang indefinitely if the network is down or
            # the servers are unreachable.  This is particularly bad
            # because Upstart cannot kill jobs stuck in the start
            # phase.  Thus a hanging ntpd job can block system
            # shutdown.
            # ${ntp}/bin/ntpd -q -g ${ntpFlags}
          '';

        exec = "${ntp}/bin/ntpd -g -n ${ntpFlags}";
      };
    
  };
  
}
