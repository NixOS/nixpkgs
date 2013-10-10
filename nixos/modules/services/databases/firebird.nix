{ config, pkgs, ... }:

# TODO: this file needs some additional work - at least you can connect to
# firebird ..
# Example how to connect:
# isql /var/db/firebird/data/your-db.fdb -u sysdba -p <default password>

# There are at least two ways to run firebird. superserver has been choosen
# however there are no strong reasons to prefer this or the other one AFAIK
# Eg superserver is said to be most efficiently using resources according to
# http://www.firebirdsql.org/manual/qsg25-classic-or-super.html

with pkgs.lib;

let

  cfg = config.services.firebird;

  firebird = cfg.package;

  pidFile = "${cfg.pidDir}/firebirdd.pid";

in

{

  ###### interface

  options = {

    services.firebird = {

      enable = mkOption {
        default = false;
        description = "
          Whether to enable the firebird super server.
        ";
      };

      package = mkOption {
        default = pkgs.firebirdSuper;
        /*
          Example: <code>package = pkgs.firebirdSuper.override { icu =
            pkgs.icu; };</code> which is not recommended for compatibility
            reasons. See comments at the firebirdSuper derivation
        */

        description = "
          Which firebird derivation to use.
        ";
      };

      port = mkOption {
        default = "3050";
        description = "Port of Firebird.";
      };

      user = mkOption {
        default = "firebird";
        description = "User account under which firebird runs.";
      };

      dataDir = mkOption {
        default = "/var/db/firebird/data"; # ubuntu is using /var/lib/firebird/2.1/data/.. ?
        description = "Location where firebird databases are stored.";
      };

      pidDir = mkOption {
        default = "/run/firebird";
        description = "Location of the file which stores the PID of the firebird server.";
      };

    };

  };


  ###### implementation

  config = mkIf config.services.firebird.enable {

    users.extraUsers.firebird.description =  "Firebird server user";

    environment.systemPackages = [firebird];

    systemd.services.firebird =
      { description = "firebird super server";

        wantedBy = [ "multi-user.target" ];

        # TODO: moving security2.fdb into the data directory works, maybe there
        # is a better way
        preStart =
          ''
            secureDir="${cfg.dataDir}/../system"

            mkdir -m 0700 -p \
              "${cfg.dataDir}" \
              "${cfg.pidDir}" \
              /var/log/firebird \
              "$secureDir"

            if ! test -e "$secureDir/security2.fdb"; then
                cp ${firebird}/security2.fdb "$secureDir"
            fi

            chown -R ${cfg.user} "${cfg.pidDir}" "${cfg.dataDir}" "$secureDir" /var/log/firebird
            chmod -R 700 "${cfg.pidDir}" "${cfg.dataDir}" "$secureDir" /var/log/firebird
          '';

        serviceConfig.PermissionsStartOnly = true; # preStart must be run as root
        serviceConfig.User = cfg.user;
        serviceConfig.ExecStart = ''${firebird}/bin/fbserver -d'';

        # TODO think about shutdown
      };

    environment.etc."firebird/firebird.msg".source = "${firebird}/firebird.msg";

    # think about this again - and eventually make it an option
    environment.etc."firebird/firebird.conf".text = ''
      # RootDirectory = Restrict ${cfg.dataDir}
      DatabaseAccess = Restrict ${cfg.dataDir}
      ExternalFileAccess = Restrict ${cfg.dataDir}
      # what is this? is None allowed?
      UdfAccess = None
      # "Native" =  traditional interbase/firebird, "mixed" is windows only
      Authentication = Native

      # defaults to -1 on non Win32
      #MaxUnflushedWrites = 100
      #MaxUnflushedWriteTime = 100

      # show trace if trouble occurs (does this require debug build?)
      # BugcheckAbort = 0
      # ConnectionTimeout = 180

      #RemoteServiceName = gds_db
      RemoteServicePort = ${cfg.port}

      # randomly choose port for server Event Notification
      #RemoteAuxPort = 0
      # rsetrict connections to a network card:
      #RemoteBindAddress =
      # there are some more settings ..
    '';
    };

}
