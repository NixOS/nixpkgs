{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.cockroachdb;

  cockroachdb = cfg.package;

in

{

  ###### interface

  options = {

    services.cockroachdb = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "
          Whether to enable the CockroachDB server.
        ";
      };

      package = mkOption {
        type = types.package;
        example = literalExample "pkgs.cockroachdb";
        description = "
          Which CockroachDB derivation to use.
        ";
      };

      cache = mkOption {
        type = types.str;
        default = "25%";
        description = "The total size for caches. This can be a percentage or any bytes-based unit.";
      };

      certsDir = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "The path to the certificate directory.";
      };

      httpHost = mkOption {
        type = types.str;
        default = "localhost";
        description = "The host to bind to for Admin UI HTTP requests.";
      };

      httpPort = mkOption {
        type = types.int;
        default = 8080;
        description = "The port to bind to for Admin UI HTTP requests.";
      };

      host = mkOption {
        type = types.nullOr types.str;
        default = "localhost";
        description = "The hostname or IP address to listen on for intra-cluster and client communication.";
      };

      insecure = mkOption {
        type = types.bool;
        default = true;
        description = "Run in insecure mode.";
      };

      join = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "The addresses for connecting the node to a cluster.";
      };

      maxSqlMemory = mkOption {
        type = types.str;
        default = "25%";
        description =
          ''
            The maximum in-memory storage capacity available to store temporary data for SQL queries.
            This can be a percentage or any bytes-based unit.
          '';
      };

      port = mkOption {
        type = types.int;
        default = 26257;
        description = "The port to bind to for internal and client communication.";
      };

      user = mkOption {
        type = types.str;
        default = "cockroachdb";
        description = "User account under which CockroachDB runs";
      };

      group = mkOption {
        type = types.str;
        default = "cockroachdb";
        description = "User account under which CockroachDB runs";
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/cockroachdb";
        example = "/var/lib/cockroachdb";
        description = "Location where MySQL stores its table files";
      };
    };

  };


  ###### implementation

  config = mkIf config.services.cockroachdb.enable {

    users.extraUsers.cockroachdb = {
      description = "CockroachDB server user";
      group = "cockroachdb";
      uid = config.ids.uids.cockroachdb;
    };

    users.extraGroups.cockroachdb.gid = config.ids.gids.cockroachdb;

    environment.systemPackages = [ cockroachdb ];

    systemd.services.cockroachdb =
      { description = "CockroachDB Server";

        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        unitConfig.RequiresMountsFor = "${cfg.dataDir}";

        preStart =
          ''
            if ! test -e ${cfg.dataDir}; then
                mkdir -m 0700 -p ${cfg.dataDir}
                chown -R ${cfg.user} ${cfg.dataDir}
            fi
          '';

        serviceConfig =
          { ExecStart = "${cockroachdb}/bin/cockroach start --logtostderr --cache=${cfg.cache} "
                      + "--http-host=${cfg.httpHost} --http-port=${toString cfg.httpPort} "
                      + "--max-sql-memory=${cfg.maxSqlMemory} --port=${toString cfg.port} "
                      + (optionalString (!isNull cfg.host) "--host=${cfg.host} ")
                      + (optionalString (!isNull cfg.join) "--join=${cfg.join} ")
                      + (if cfg.insecure then "--insecure " else "--certs-dir=${cfg.certsDir} ")
                      + "--store=${cfg.dataDir} ";
            User = cfg.user;
            PermissionsStartOnly = true;
          };
      };
  };

}
