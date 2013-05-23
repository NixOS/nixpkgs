{ config, pkgs, ... }:

with pkgs.lib;

let

  inherit (pkgs) chrony;

  stateDir = "/var/lib/chrony";

  chronyUser = "chrony";

  cfg = config.services.chrony;

  configFile = pkgs.writeText "chrony.conf" ''
    ${toString (map (server: "server " + server + "\n") cfg.servers)}

    ${optionalString cfg.initstepslew.enabled ''
      initstepslew ${toString cfg.initstepslew.threshold} ${toString (map (server: server + " ") cfg.initstepslew.servers)}
    ''}

    driftfile ${stateDir}/chrony.drift

    ${optionalString (!config.time.hardwareClockInLocalTime) "rtconutc"}

    ${cfg.extraConfig}
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

      initstepslew = mkOption {
        default = {
          enabled = true;
          threshold = 1000; # by default, same threshold as 'ntpd -g' (1000s)
          servers = cfg.servers;
        };
        description = ''
          Allow chronyd to make a rapid measurement of the system clock error at
          boot time, and to correct the system clock by stepping before normal
          operation begins.
        '';
      };

      extraConfig = mkOption {
        default = "";
        description = ''
          Extra configuration directives that should be added to
          <literal>chrony.conf</literal>
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
