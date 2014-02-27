{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.couchdb;
  configFile = pkgs.writeText "couchdb.ini"
    ''
      [couchdb]
      database_dir = ${cfg.databaseDir}
      uri_file = ${cfg.uriFile}
      view_index_dir = ${cfg.viewIndexDir}

      [httpd]
      port = ${toString cfg.port}
      bind_address = ${cfg.bindAddress}

      [log]
      file = ${cfg.logFile}
    '';
  configExtraFile = pkgs.writeText "couchdb-extra.ini" cfg.extraConfig;

in
{

  ###### interface

  options = {

    services.couchdb = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to run CouchDB Server.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.couchdb;
        example = literalExample "pkgs.couchdb";
        description = ''
          CouchDB package to use.
        '';
      };


      user = mkOption {
        type = types.string;
        default = "couchdb";
        description = ''
          User account under which couchdb runs.
        '';
      };

      group = mkOption {
        type = types.string;
        default = "couchdb";
        description = ''
          Group account under which couchdb runs.
        '';
      };

      pidFile = mkOption {
        type = types.path;
        default = "/var/run/couchdb/couchdb.pid";
        description = ''
          pid file.
        '';
      };

      # couchdb options: http://docs.couchdb.org/en/latest/config/index.html

      databaseDir = mkOption {
        type = types.path;
        default = "/var/lib/couchdb";
        description = ''
          Specifies location of CouchDB database files (*.couch named). This
          location should be writable and readable for the user the CouchDB
          service runs as (couchdb by default).
        '';
      };

      uriFile = mkOption {
        type = types.path;
        default = "/var/run/couchdb/couchdb.uri";
        description = ''
          This file contains the full URI that can be used to access this
          instance of CouchDB. It is used to help discover the port CouchDB is
          running on (if it was set to 0 (e.g. automatically assigned any free
          one). This file should be writable and readable for the user that
          runs the CouchDB service (couchdb by default).
        '';
      };

      viewIndexDir = mkOption {
        type = types.path;
        default = "/var/lib/couchdb";
        description = ''
          Specifies location of CouchDB view index files. This location should
          be writable and readable for the user that runs the CouchDB service
          (couchdb by default).
        '';
      };

      bindAddress = mkOption {
        type = types.string;
        default = "127.0.0.1";
        description = ''
          Defines the IP address by which CouchDB will be accessible.
        '';
      };

      port = mkOption {
        type = types.int;
        default = 5984;
        description = ''
          Defined the port number to listen.
        '';
      };

      logFile = mkOption {
        type = types.path;
        default = "/var/log/couchdb.log";
        description = ''
          Specifies the location of file for logging output.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        description = ''
          Extra configuration. Overrides any other cofiguration.
        '';
      };
    };

  };

  ###### implementation

  config = mkIf config.services.couchdb.enable {

    environment.systemPackages = [ cfg.package ];

    systemd.services.couchdb = {
      description = "CouchDB Server";
      wantedBy = [ "multi-user.target" ];

      preStart =
        ''
        mkdir -p `dirname ${cfg.pidFile}`;
        mkdir -p `dirname ${cfg.uriFile}`;
        mkdir -p `dirname ${cfg.logFile}`;
        touch ${cfg.logFile};
        mkdir -p ${cfg.databaseDir};
        mkdir -p ${cfg.viewIndexDir};
        chown ${cfg.user}:${cfg.group} `dirname ${cfg.pidFile}`
        chown ${cfg.user}:${cfg.group} `dirname ${cfg.uriFile}`
        chown ${cfg.user}:${cfg.group} ${cfg.logFile}
        chown ${cfg.user}:${cfg.group} ${cfg.databaseDir}
        chown ${cfg.user}:${cfg.group} ${cfg.viewIndexDir}
        '';

      serviceConfig = {
        PermissionsStartOnly = true;
        User = cfg.user;
        Group = cfg.group;
        Type = "forking";
        ExecStart = "${cfg.package}/bin/couchdb -b -o /dev/null -e /dev/null -p ${cfg.pidFile} -a ${configFile} -a ${configExtraFile}";
        ExecStop = "${cfg.package}/bin/couchdb -d";
      };
    };

    users.extraUsers.couchdb = {
      description = "CouchDB Server user";
      group = "couchdb";
      uid = config.ids.uids.couchdb;
    };

    users.extraGroups.couchdb.gid = config.ids.gids.couchdb;

  };
}
