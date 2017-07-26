{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.mongodb;

  mongodb = cfg.package;

  mongoCnf = pkgs.writeText "mongodb.conf"
  ''
    net.bindIp: ${cfg.bind_ip}
    ${optionalString cfg.quiet "systemLog.quiet: true"}
    systemLog.destination: syslog
    storage.dbPath: ${cfg.dbpath}
    ${optionalString (cfg.replSetName != "") "replication.replSetName: ${cfg.replSetName}"}
    ${cfg.extraConfig}
  '';

in

{

  ###### interface

  options = {

    services.mongodb = {

      enable = mkOption {
        default = false;
        description = "
          Whether to enable the MongoDB server.
        ";
      };

      package = mkOption {
        default = pkgs.mongodb;
        defaultText = "pkgs.mongodb";
        type = types.package;
        description = "
          Which MongoDB derivation to use.
        ";
      };

      user = mkOption {
        default = "mongodb";
        description = "User account under which MongoDB runs";
      };

      bind_ip = mkOption {
        default = "127.0.0.1";
        description = "IP to bind to";
      };

      quiet = mkOption {
        default = false;
        description = "quieter output";
      };

      dbpath = mkOption {
        default = "/var/db/mongodb";
        description = "Location where MongoDB stores its files";
      };

      pidFile = mkOption {
        default = "/var/run/mongodb.pid";
        description = "Location of MongoDB pid file";
      };

      replSetName = mkOption {
        default = "";
        description = ''
          If this instance is part of a replica set, set its name here.
          Otherwise, leave empty to run as single node.
        '';
      };

      extraConfig = mkOption {
        default = "";
        example = ''
          storage.journal.enabled: false
        '';
        description = "MongoDB extra configuration in YAML format";
      };
    };

  };


  ###### implementation

  config = mkIf config.services.mongodb.enable {

    users.extraUsers.mongodb = mkIf (cfg.user == "mongodb")
      { name = "mongodb";
        uid = config.ids.uids.mongodb;
        description = "MongoDB server user";
      };

    environment.systemPackages = [ mongodb ];

    systemd.services.mongodb =
      { description = "MongoDB server";

        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        serviceConfig = {
          ExecStart = "${mongodb}/bin/mongod --quiet --config ${mongoCnf} --fork --pidfilepath ${cfg.pidFile}";
          User = cfg.user;
          PIDFile = cfg.pidFile;
          Type = "forking";
          TimeoutStartSec=120; # intial creating of journal can take some time
          PermissionsStartOnly = true;
        };

        preStart = ''
          rm ${cfg.dbpath}/mongod.lock || true
          if ! test -e ${cfg.dbpath}; then
              install -d -m0700 -o ${cfg.user} ${cfg.dbpath}
          fi
          if ! test -e ${cfg.pidFile}; then
              install -D -o ${cfg.user} /dev/null ${cfg.pidFile}
          fi
        '';
      };

  };

}
