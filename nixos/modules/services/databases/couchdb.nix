{
  config,
  options,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.couchdb;
  opt = options.services.couchdb;

  baseConfig = {
    couchdb = {
      database_dir = cfg.databaseDir;
      uri_file = cfg.uriFile;
      view_index_dir = cfg.viewIndexDir;
    };
    chttpd = {
      port = cfg.port;
      bind_address = cfg.bindAddress;
    };
    log = {
      file = cfg.logFile;
    };
  };
  adminConfig = lib.optionalAttrs (cfg.adminPass != null) {
    admins = {
      "${cfg.adminUser}" = cfg.adminPass;
    };
  };
  appConfig = lib.recursiveUpdate (lib.recursiveUpdate baseConfig adminConfig) cfg.extraConfig;

  optionsConfigFile = pkgs.writeText "couchdb.ini" (lib.generators.toINI { } appConfig);

  # we are actually specifying 5 configuration files:
  # 1. the preinstalled default.ini
  # 2. the module configuration
  # 3. the extraConfigFiles from the module options
  # 4. the locally writable config file, which couchdb itself writes to
  configFiles = [
    "${cfg.package}/etc/default.ini"
    optionsConfigFile
  ]
  ++ cfg.extraConfigFiles
  ++ [ cfg.configFile ];
  executable = "${cfg.package}/bin/couchdb";
in
{
  ###### interface

  options = {
    services.couchdb = {
      enable = lib.mkEnableOption "CouchDB Server";

      package = lib.mkPackageOption pkgs "couchdb3" { };

      adminUser = lib.mkOption {
        type = lib.types.str;
        default = "admin";
        description = ''
          Couchdb (i.e. fauxton) account with permission for all dbs and
          tasks.
        '';
      };

      adminPass = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Couchdb (i.e. fauxton) account with permission for all dbs and
          tasks.
        '';
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "couchdb";
        description = ''
          User account under which couchdb runs.
        '';
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "couchdb";
        description = ''
          Group account under which couchdb runs.
        '';
      };

      # couchdb options: https://docs.couchdb.org/en/latest/config/index.html

      databaseDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/couchdb";
        description = ''
          Specifies location of CouchDB database files (*.couch named). This
          location should be writable and readable for the user the CouchDB
          service runs as (couchdb by default).
        '';
      };

      uriFile = lib.mkOption {
        type = lib.types.path;
        default = "/run/couchdb/couchdb.uri";
        description = ''
          This file contains the full URI that can be used to access this
          instance of CouchDB. It is used to help discover the port CouchDB is
          running on (if it was set to 0 (e.g. automatically assigned any free
          one). This file should be writable and readable for the user that
          runs the CouchDB service (couchdb by default).
        '';
      };

      viewIndexDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/couchdb";
        description = ''
          Specifies location of CouchDB view index files. This location should
          be writable and readable for the user that runs the CouchDB service
          (couchdb by default).
        '';
      };

      bindAddress = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = ''
          Defines the IP address by which CouchDB will be accessible.
        '';
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 5984;
        description = ''
          Defined the port number to listen.
        '';
      };

      logFile = lib.mkOption {
        type = lib.types.path;
        default = "/var/log/couchdb.log";
        description = ''
          Specifies the location of file for logging output.
        '';
      };

      extraConfig = lib.mkOption {
        type = lib.types.attrs;
        default = { };
        description = "Extra configuration options for CouchDB";
      };
      extraConfigFiles = lib.mkOption {
        type = lib.types.listOf lib.types.path;
        default = [ ];
        description = ''
          Extra configuration files. Overrides any other configuration. You can use this to setup the Admin user without putting the password in your nix store.
        '';
      };

      argsFile = lib.mkOption {
        type = lib.types.path;
        default = "${cfg.package}/etc/vm.args";
        defaultText = lib.literalExpression ''"config.${opt.package}/etc/vm.args"'';
        description = ''
          vm.args configuration. Overrides Couchdb's Erlang VM parameters file.
        '';
      };

      configFile = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/couchdb/local.ini";
        description = ''
          Configuration file for persisting runtime changes. File
          needs to be readable and writable from couchdb user/group.
        '';
      };
    };
  };

  ###### implementation

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

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
        ERL_FLAGS = ''-couch_ini ${lib.concatStringsSep " " configFiles}'';
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
