{ config, pkgs, ... }:

with pkgs.lib;

let

  inherit (pkgs) chrony;

  stateDir = "/var/lib/chrony";

  chronyUser = "chrony";

  configFile = pkgs.writeText "chrony.conf" ''
    ${toString (map (server: "server " + server + "\n") config.services.chrony.servers)}

    driftfile ${stateDir}/chrony.drift
  '';

  chronyFlags = "-m -f ${configFile} -u ${chronyUser}";

in

{

  ###### interface

  options = {

    services.chrony = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to synchronise your machine's time using chrony.
          Make sure you disable NTP if you enable this service.
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

  config = mkIf config.services.chrony.enable {

    # Make chronyc available in the system path
    environment.systemPackages = [ pkgs.chrony ];

    users.extraUsers = singleton
      { name = chronyUser;
        uid = config.ids.uids.chrony;
        description = "chrony daemon user";
        home = stateDir;
      };

    jobs.chronyd =
      { description = "chrony daemon";

        wantedBy = [ "ip-up.target" ];
        partOf = [ "ip-up.target" ];

        path = [ chrony ];

        preStart =
          ''
            mkdir -m 0755 -p ${stateDir}
            chown ${chronyUser} ${stateDir}
          '';

        exec = "chronyd -n ${chronyFlags}";
      };

  };

}
