{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.mongodb;

  mongodb = cfg.package;

  mongoCnf = cfg: pkgs.writeText "mongodb.conf"
  ''
    net.bindIp: ${cfg.bind_ip}
    ${optionalString cfg.quiet "systemLog.quiet: true"}
    systemLog.destination: syslog
    storage.dbPath: ${cfg.dbpath}
    ${optionalString cfg.enableAuth "security.authorization: enabled"}
    ${optionalString (cfg.replSetName != "") "replication.replSetName: ${cfg.replSetName}"}
    ${cfg.extraConfig}
  '';

in

{

  ###### interface

  options = {

    services.mongodb = {

      enable = mkEnableOption (lib.mdDoc "the MongoDB server");

      package = mkOption {
        default = pkgs.mongodb;
        defaultText = literalExpression "pkgs.mongodb";
        type = types.package;
        description = lib.mdDoc ''
          Which MongoDB derivation to use.
        '';
      };

      user = mkOption {
        type = types.str;
        default = "mongodb";
        description = lib.mdDoc "User account under which MongoDB runs";
      };

      bind_ip = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = lib.mdDoc "IP to bind to";
      };

      quiet = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "quieter output";
      };

      enableAuth = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Enable client authentication. Creates a default superuser with username root!";
      };

      initialRootPassword = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc "Password for the root user if auth is enabled.";
      };

      dbpath = mkOption {
        type = types.str;
        default = "/var/db/mongodb";
        description = lib.mdDoc "Location where MongoDB stores its files";
      };

      pidFile = mkOption {
        type = types.str;
        default = "/run/mongodb.pid";
        description = lib.mdDoc "Location of MongoDB pid file";
      };

      replSetName = mkOption {
        type = types.str;
        default = "";
        description = lib.mdDoc ''
          If this instance is part of a replica set, set its name here.
          Otherwise, leave empty to run as single node.
        '';
      };

      extraConfig = mkOption {
        type = types.lines;
        default = "";
        example = ''
          storage.journal.enabled: false
        '';
        description = lib.mdDoc "MongoDB extra configuration in YAML format";
      };

      initialScript = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = lib.mdDoc ''
          A file containing MongoDB statements to execute on first startup.
        '';
      };
    };

  };


  ###### implementation

  config = mkIf config.services.mongodb.enable {
    assertions = [
      { assertion = !cfg.enableAuth || cfg.initialRootPassword != null;
        message = "`enableAuth` requires `initialRootPassword` to be set.";
      }
    ];

    users.users.mongodb = mkIf (cfg.user == "mongodb")
      { name = "mongodb";
        isSystemUser = true;
        group = "mongodb";
        description = "MongoDB server user";
      };
    users.groups.mongodb = mkIf (cfg.user == "mongodb") {};

    environment.systemPackages = [ mongodb ];

    systemd.services.mongodb =
      { description = "MongoDB server";

        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        serviceConfig = {
          ExecStart = "${mongodb}/bin/mongod --config ${mongoCnf cfg} --fork --pidfilepath ${cfg.pidFile}";
          User = cfg.user;
          PIDFile = cfg.pidFile;
          Type = "forking";
          TimeoutStartSec=120; # intial creating of journal can take some time
          PermissionsStartOnly = true;
        };

        preStart = let
          cfg_ = cfg // { enableAuth = false; bind_ip = "127.0.0.1"; };
        in ''
          rm ${cfg.dbpath}/mongod.lock || true
          if ! test -e ${cfg.dbpath}; then
              install -d -m0700 -o ${cfg.user} ${cfg.dbpath}
              # See postStart!
              touch ${cfg.dbpath}/.first_startup
          fi
          if ! test -e ${cfg.pidFile}; then
              install -D -o ${cfg.user} /dev/null ${cfg.pidFile}
          fi '' + lib.optionalString cfg.enableAuth ''

          if ! test -e "${cfg.dbpath}/.auth_setup_complete"; then
            systemd-run --unit=mongodb-for-setup --uid=${cfg.user} ${mongodb}/bin/mongod --config ${mongoCnf cfg_}
            # wait for mongodb
            while ! ${mongodb}/bin/mongo --eval "db.version()" > /dev/null 2>&1; do sleep 0.1; done

          ${mongodb}/bin/mongo <<EOF
            use admin
            db.createUser(
              {
                user: "root",
                pwd: "${cfg.initialRootPassword}",
                roles: [
                  { role: "userAdminAnyDatabase", db: "admin" },
                  { role: "dbAdminAnyDatabase", db: "admin" },
                  { role: "readWriteAnyDatabase", db: "admin" }
                ]
              }
            )
          EOF
            touch "${cfg.dbpath}/.auth_setup_complete"
            systemctl stop mongodb-for-setup
          fi
        '';
        postStart = ''
            if test -e "${cfg.dbpath}/.first_startup"; then
              ${optionalString (cfg.initialScript != null) ''
                ${mongodb}/bin/mongo ${optionalString (cfg.enableAuth) "-u root -p ${cfg.initialRootPassword}"} admin "${cfg.initialScript}"
              ''}
              rm -f "${cfg.dbpath}/.first_startup"
            fi
        '';
      };

  };

}
