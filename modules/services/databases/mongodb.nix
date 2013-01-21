{ config, pkgs, ... }:

with pkgs.lib;

let

  b2s = x: if x then "true" else "false";

  cfg = config.services.mongodb;

  mongodb = cfg.package;

  mongoCnf = pkgs.writeText "mongodb.conf"
  ''
    bind_ip = ${cfg.bind_ip}
    ${optionalString cfg.quiet "quiet = true"}
    dbpath = ${cfg.dbpath}
    logpath = ${cfg.logpath}
    logappend = ${b2s cfg.logappend}
    ${optionalString (cfg.replSetName != "") "replSet = ${cfg.replSetName}"}
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
        default = pkgs.mongodb.override { useV8 = cfg.useV8; };
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

      logpath = mkOption {
        default = "/var/log/mongodb/mongod.log";
        description = "Location where MongoDB stores its logfile";
      };

      logappend = mkOption {
        default = true;
        description = "Append logfile instead over overwriting";
      };

      useV8 = mkOption {
        default = false;
        description = "Use V8 instead of spidermonkey for js execution";
      };

      replSetName = mkOption {
        default = "";
        description = ''
          If this instance is part of a replica set, set its name here.
          Otherwise, leave empty to run as single node.
        '';
      };
    };

  };


  ###### implementation

  config = mkIf config.services.mongodb.enable {

    users.extraUsers = singleton
      { name = cfg.user;
        description = "MongoDB server user";
      };

    environment.systemPackages = [ mongodb ];

    systemd.services.mongodb =
      { description = "MongoDB server";

        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        preStart =
          ''
            if ! test -e ${cfg.dbpath}; then
                install -d -m0700 -o ${cfg.user} ${cfg.dbpath}
                install -d -m0755 -o ${cfg.user} `dirname ${cfg.logpath}`
            fi
          '';

        serviceConfig = {
          ExecStart = "${mongodb}/bin/mongod --quiet --config ${mongoCnf}";
          User = cfg.user;
        };
      };

  };

}
