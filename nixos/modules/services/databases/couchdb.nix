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
        type = types.path;
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
        type = types.string;
        default = "/var/run/couchdb/couchdb.pid";
        description = ''
          pid file.
        '';
      };

      # couchdb options: http://docs.couchdb.org/en/latest/config/index.html

      databaseDir = mkOption {
        type = types.string;
        default = "/var/lib/couchdb";
        description = ''
          Specifies location of CouchDB database files (*.couch named). This
          location should be writable and readable for the user the CouchDB
          service runs as (couchdb by default).
        '';
      };

      uriFile = mkOption {
        type = types.string;
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
        type = types.string;
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
        type = types.string;
        default = "/var/log/couchdb.log";
        description = ''
          Specifies the location of file for logging output.
        '';
      };

      extraConfig = mkOption {
        type = types.string;
        default = "";
        description = ''
          Extra configuration. Overrides any other cofiguration.
        '';
      };

      customConfigFile = mkOption {
        type = types.string;
        default = "/var/lib/couchdb/custom.ini";
        description = ''
          Custom configuration file. File needs to be readable and writable
          from couchdb user/group.
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
        if ! test -e ${cfg.pidFile}; then
          mkdir -p `dirname ${cfg.pidFile}`;
        fi
        if ! test -e ${cfg.uriFile}; then
          mkdir -p `dirname ${cfg.uriFile}`;
        fi
        if ! test -e ${cfg.logFile}; then
          mkdir -p `dirname ${cfg.logFile}`;
          touch ${cfg.logFile};
        fi
        if ! test -e ${cfg.customConfigFile}; then
          mkdir -p `dirname ${cfg.customConfigFile}`;
          touch ${cfg.customConfigFile};
        fi
        if ! test -e ${cfg.databaseDir}; then
          mkdir -p ${cfg.databaseDir};
        fi
        if ! test -e ${cfg.viewIndexDir}; then
          mkdir -p ${cfg.viewIndexDir};
        fi
        chown ${cfg.user}:${cfg.group} `dirname ${cfg.pidFile}`
        chown ${cfg.user}:${cfg.group} `dirname ${cfg.uriFile}`
        chown ${cfg.user}:${cfg.group} ${cfg.logFile}
        chown ${cfg.user}:${cfg.group} ${cfg.customConfigFile}
        chown ${cfg.user}:${cfg.group} ${cfg.databaseDir}
        chown ${cfg.user}:${cfg.group} ${cfg.viewIndexDir}
        '';

      serviceConfig = {
        PermissionsStartOnly = true;
        User = cfg.user;
        Group = cfg.group;
        Type = "forking";
        ExecStart = "${cfg.package}/bin/couchdb -b -o /dev/null -e /dev/null -p ${cfg.pidFile} -a ${configFile} -a ${configExtraFile} -a ${cfg.customConfigFile}";
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
