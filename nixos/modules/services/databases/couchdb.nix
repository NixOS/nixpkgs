{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.couchdb;
  useVersion2 = strings.versionAtLeast (strings.getVersion cfg.package) "2.0";
  configFile = pkgs.writeText "couchdb.ini" (
    ''
      [couchdb]
      database_dir = ${cfg.databaseDir}
      uri_file = ${cfg.uriFile}
      view_index_dir = ${cfg.viewIndexDir}
    '' + (if useVersion2 then
    ''
      [chttpd]
    '' else
    ''
      [httpd]
    '') +
    ''
      port = ${toString cfg.port}
      bind_address = ${cfg.bindAddress}

      [log]
      file = ${cfg.logFile}
    '');
  executable = if useVersion2 then "${cfg.package}/bin/couchdb"
    else ''${cfg.package}/bin/couchdb -a ${configFile} -a ${pkgs.writeText "couchdb-extra.ini" cfg.extraConfig} -a ${cfg.configFile}'';

in {

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
        defaultText = "pkgs.couchdb";
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
        default = "/run/couchdb/couchdb.uri";
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

      configFile = mkOption {
        type = types.string;
        description = ''
          Configuration file for persisting runtime changes. File
          needs to be readable and writable from couchdb user/group.
        '';
      };

    };

  };

  ###### implementation

  config = mkIf config.services.couchdb.enable {

    environment.systemPackages = [ cfg.package ];

    services.couchdb.configFile = mkDefault
      (if useVersion2 then "/var/lib/couchdb/local.ini" else "/var/lib/couchdb/couchdb.ini");

    systemd.services.couchdb = {
      description = "CouchDB Server";
      wantedBy = [ "multi-user.target" ];

      preStart =
        ''
        mkdir -p `dirname ${cfg.uriFile}`;
        mkdir -p `dirname ${cfg.logFile}`;
        mkdir -p ${cfg.databaseDir};
        mkdir -p ${cfg.viewIndexDir};
        touch ${cfg.configFile}
        touch -a ${cfg.logFile}

        if [ "$(id -u)" = 0 ]; then
          chown ${cfg.user}:${cfg.group} `dirname ${cfg.uriFile}`;
          (test -f ${cfg.uriFile} && chown ${cfg.user}:${cfg.group} ${cfg.uriFile}) || true
          chown ${cfg.user}:${cfg.group} ${cfg.databaseDir}
          chown ${cfg.user}:${cfg.group} ${cfg.viewIndexDir}
          chown ${cfg.user}:${cfg.group} ${cfg.configFile}
          chown ${cfg.user}:${cfg.group} ${cfg.logFile}
        fi
        '';

      environment = mkIf useVersion2 {
        # we are actually specifying 4 configuration files:
        # 1. the preinstalled default.ini
        # 2. the module configuration
        # 3. the extraConfig from the module options
        # 4. the locally writable config file, which couchdb itself writes to
        ERL_FLAGS= ''-couch_ini ${cfg.package}/etc/default.ini ${configFile} ${pkgs.writeText "couchdb-extra.ini" cfg.extraConfig} ${cfg.configFile}'';
      };

      serviceConfig = {
        PermissionsStartOnly = true;
        User = cfg.user;
        Group = cfg.group;
        ExecStart = executable;
      };
    };

    users.users.couchdb = {
      description = "CouchDB Server user";
      group = "couchdb";
      uid = config.ids.uids.couchdb;
    };

    users.groups.couchdb.gid = config.ids.gids.couchdb;

  };
}
