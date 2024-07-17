{
  config,
  options,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.couchdb;
  opt = options.services.couchdb;
  configFile = pkgs.writeText "couchdb.ini" (
    ''
      [couchdb]
      database_dir = ${cfg.databaseDir}
      uri_file = ${cfg.uriFile}
      view_index_dir = ${cfg.viewIndexDir}
    ''
    + (
      optionalString (cfg.adminPass != null) ''
        [admins]
        ${cfg.adminUser} = ${cfg.adminPass}
      ''
      + ''
        [chttpd]
      ''
    )
    + ''
      port = ${toString cfg.port}
      bind_address = ${cfg.bindAddress}

      [log]
      file = ${cfg.logFile}
    ''
  );
  executable = "${cfg.package}/bin/couchdb";

in
{

  ###### interface

  options = {

    services.couchdb = {

      enable = mkEnableOption "CouchDB Server";

      package = mkPackageOption pkgs "couchdb3" { };

      adminUser = mkOption {
        type = types.str;
        default = "admin";
        description = ''
          Couchdb (i.e. fauxton) account with permission for all dbs and
          tasks.
        '';
      };

      adminPass = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          Couchdb (i.e. fauxton) account with permission for all dbs and
          tasks.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "couchdb";
        description = ''
          User account under which couchdb runs.
        '';
      };

      group = mkOption {
        type = types.str;
        default = "couchdb";
        description = ''
          Group account under which couchdb runs.
        '';
      };

      # couchdb options: https://docs.couchdb.org/en/latest/config/index.html

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
        type = types.str;
        default = "127.0.0.1";
        description = ''
          Defines the IP address by which CouchDB will be accessible.
        '';
      };

      port = mkOption {
        type = types.port;
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
          Extra configuration. Overrides any other configuration.
        '';
      };

      argsFile = mkOption {
        type = types.path;
        default = "${cfg.package}/etc/vm.args";
        defaultText = literalExpression ''"config.${opt.package}/etc/vm.args"'';
        description = ''
          vm.args configuration. Overrides Couchdb's Erlang VM parameters file.
        '';
      };

      configFile = mkOption {
        type = types.path;
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

    services.couchdb.configFile = mkDefault "/var/lib/couchdb/local.ini";

    systemd.tmpfiles.rules = [
      "d '${dirOf cfg.uriFile}' - ${cfg.user} ${cfg.group} - -"
      "f '${cfg.logFile}' - ${cfg.user} ${cfg.group} - -"
      "d '${cfg.databaseDir}' -  ${cfg.user} ${cfg.group} - -"
      "d '${cfg.viewIndexDir}' -  ${cfg.user} ${cfg.group} - -"
    ];

    systemd.services.couchdb = {
      description = "CouchDB Server";
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        touch ${cfg.configFile}
        if ! test -e ${cfg.databaseDir}/.erlang.cookie; then
          touch ${cfg.databaseDir}/.erlang.cookie
          chmod 600 ${cfg.databaseDir}/.erlang.cookie
          dd if=/dev/random bs=16 count=1 | base64 > ${cfg.databaseDir}/.erlang.cookie
        fi
      '';

      environment = {
        # we are actually specifying 5 configuration files:
        # 1. the preinstalled default.ini
        # 2. the module configuration
        # 3. the extraConfig from the module options
        # 4. the locally writable config file, which couchdb itself writes to
        ERL_FLAGS = ''-couch_ini ${cfg.package}/etc/default.ini ${configFile} ${pkgs.writeText "couchdb-extra.ini" cfg.extraConfig} ${cfg.configFile}'';
        # 5. the vm.args file
        COUCHDB_ARGS_FILE = ''${cfg.argsFile}'';
        HOME = ''${cfg.databaseDir}'';
      };

      serviceConfig = {
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
