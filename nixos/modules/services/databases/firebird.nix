{ config, lib, pkgs, ... }:

# TODO: This may file may need additional review, eg which configuartions to
# expose to the user.
#
# I only used it to access some simple databases.

# test:
# isql, then type the following commands:
# CREATE DATABASE '/var/db/firebird/data/test.fdb' USER 'SYSDBA' PASSWORD 'masterkey';
# CONNECT '/var/db/firebird/data/test.fdb' USER 'SYSDBA' PASSWORD 'masterkey';
# CREATE TABLE test ( text varchar(100) );
# DROP DATABASE;
#
# Be careful, virtuoso-opensource also provides a different isql command !

# There are at least two ways to run firebird. superserver has been choosen
# however there are no strong reasons to prefer this or the other one AFAIK
# Eg superserver is said to be most efficiently using resources according to
# http://www.firebirdsql.org/manual/qsg25-classic-or-super.html

with lib;

let

  cfg = config.services.firebird;

  firebird = cfg.package;

  dataDir = "${cfg.baseDir}/data";
  systemDir = "${cfg.baseDir}/system";

in

{

  ###### interface

  options = {

    services.firebird = {

      enable = mkEnableOption (lib.mdDoc "the Firebird super server");

      package = mkOption {
        default = pkgs.firebird;
        defaultText = literalExpression "pkgs.firebird";
        type = types.package;
        example = literalExpression "pkgs.firebird_3";
        description = lib.mdDoc ''
          Which Firebird package to be installed: `pkgs.firebird_3`
          For SuperServer use override: `pkgs.firebird_3.override { superServer = true; };`
        '';
      };

      port = mkOption {
        default = 3050;
        type = types.port;
        description = lib.mdDoc ''
          Port Firebird uses.
        '';
      };

      user = mkOption {
        default = "firebird";
        type = types.str;
        description = lib.mdDoc ''
          User account under which firebird runs.
        '';
      };

      baseDir = mkOption {
        default = "/var/lib/firebird";
        type = types.str;
        description = lib.mdDoc ''
          Location containing data/ and system/ directories.
          data/ stores the databases, system/ stores the password database security2.fdb.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.firebird.enable {

    environment.systemPackages = [cfg.package];

    systemd.tmpfiles.rules = [
      "d '${dataDir}' 0700 ${cfg.user} - - -"
      "d '${systemDir}' 0700 ${cfg.user} - - -"
    ];

    systemd.services.firebird =
      { description = "Firebird Super-Server";

        wantedBy = [ "multi-user.target" ];

        # TODO: moving security2.fdb into the data directory works, maybe there
        # is a better way
        preStart =
          ''
            if ! test -e "${systemDir}/security2.fdb"; then
                cp ${firebird}/security2.fdb "${systemDir}"
            fi

            if ! test -e "${systemDir}/security3.fdb"; then
                cp ${firebird}/security3.fdb "${systemDir}"
            fi

            if ! test -e "${systemDir}/security4.fdb"; then
                cp ${firebird}/security4.fdb "${systemDir}"
            fi

            chmod -R 700         "${dataDir}" "${systemDir}" /var/log/firebird
          '';

        serviceConfig.User = cfg.user;
        serviceConfig.LogsDirectory = "firebird";
        serviceConfig.LogsDirectoryMode = "0700";
        serviceConfig.ExecStart = "${firebird}/bin/fbserver -d";

        # TODO think about shutdown
      };

    environment.etc."firebird/firebird.msg".source = "${firebird}/firebird.msg";

    # think about this again - and eventually make it an option
    environment.etc."firebird/firebird.conf".text = ''
      # RootDirectory = Restrict ${dataDir}
      DatabaseAccess = Restrict ${dataDir}
      ExternalFileAccess = Restrict ${dataDir}
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
      # there are some additional settings which should be reviewed
    '';

    users.users.firebird = {
      description = "Firebird server user";
      group = "firebird";
      uid = config.ids.uids.firebird;
    };

    users.groups.firebird.gid = config.ids.gids.firebird;

  };
}
