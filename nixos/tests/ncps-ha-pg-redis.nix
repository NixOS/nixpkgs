{
  lib,
  pkgs,
  ...
}:
let
  # s3 creds (Garage requires the access key id to be GK + 24 hex chars and the
  # secret key to be 64 hex chars)
  bucket = "ncps";
  region = "us-west-1";
  garageAccessKey = "GKaaaaaaaaaaaaaaaaaaaaaaaa";
  garageSecretKey = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
  garageRpcSecret = "5c1915fa04d0b6739675c61bf5907eb0fe3d9c69850c83820f51b4d25d13868c";
  accessKey = builtins.toFile "garage-access-key" garageAccessKey;
  secretKey = builtins.toFile "garage-secret-key" garageSecretKey;

  # pg creds
  postgresPassword = "easypwd";

  # redis creds
  redisPassword = "easypwd";

  ncpsAttrs = hostname: {
    services.ncps = {
      enable = true;

      analytics.reporting.enable = false;

      cache = {
        hostName = hostname;

        databaseURL = "postgres://ncps:${lib.escapeURL postgresPassword}@postgres:5432/ncps?sslmode=disable";

        lock.backend = "redis";

        secretKeyPath = builtins.toString (
          pkgs.writeText "ncps-cache-key" "ncps:dcrGsrku0KvltFhrR5lVIMqyloAdo0y8vYZOeIFUSLJS2IToL7dPHSSCk/fi+PJf8EorpBn8PU7MNhfvZoI8mA=="
        );

        redis = {
          addresses = [ "redis:6379" ];
          passwordFile = builtins.toFile "redis-password" redisPassword;
        };

        storage.s3 = {
          inherit bucket region;

          endpoint = "http://garage:3900";

          # Garage only supports path-style addressing.
          forcePathStyle = true;

          accessKeyIdPath = accessKey;
          secretAccessKeyPath = secretKey;
        };

        upstream = {
          urls = [ "http://harmonia:5000" ];
          publicKeys = [
            "cache.example.com-1:eIGQXcGQpc00x6/XFcyacLEUmC07u4RAEHt5Y8vdglo="
          ];
        };
      };
    };

    networking.firewall.allowedTCPPorts = [ 8501 ];
  };
in
{
  name = "ncps-storage-s3";
  meta = with lib.maintainers; {
    maintainers = [
      aciceri
      kalbasit
    ];
  };

  nodes = {
    client0 = {
      nix.settings = {
        substituters = lib.mkForce [ "http://ncps0:8501" ];
        trusted-public-keys = lib.mkForce [
          "ncps:UtiE6C+3Tx0kgpP34vjyX/BKK6QZ/D1OzDYX72aCPJg="
        ];
      };
    };

    client1 = {
      nix.settings = {
        substituters = lib.mkForce [ "http://ncps1:8501" ];
        trusted-public-keys = lib.mkForce [
          "ncps:UtiE6C+3Tx0kgpP34vjyX/BKK6QZ/D1OzDYX72aCPJg="
        ];
      };
    };

    harmonia = {
      services.harmonia = {
        enable = true;
        signKeyPaths = [
          (pkgs.writeText "cache-key" "cache.example.com-1:9FhO0w+7HjZrhvmzT1VlAZw4OSAlFGTgC24Seg3tmPl4gZBdwZClzTTHr9cVzJpwsRSYLTu7hEAQe3ljy92CWg==")
        ];
        settings.priority = 35;
      };

      networking.firewall.allowedTCPPorts = [ 5000 ];
      system.extraDependencies = [ pkgs.emptyFile ];
    };

    garage =
      { config, ... }:
      {
        services.garage = {
          enable = true;
          package = pkgs.garage_2;
          settings = {
            replication_factor = 1;
            consistency_mode = "consistent";
            rpc_bind_addr = "[::]:3901";
            rpc_public_addr = "[::1]:3901";
            rpc_secret = garageRpcSecret;
            s3_api = {
              s3_region = region;
              api_bind_addr = "[::]:3900";
            };
          };
        };

        networking.firewall.allowedTCPPorts = [ 3900 ];
        environment.systemPackages = [ config.services.garage.package ];
        # Garage requires at least 1GiB of free disk space to run.
        virtualisation.diskSize = 2048;
      };

    ncps0 = lib.mkMerge [
      (ncpsAttrs "ncps0")
      {
        services.ncps.cache.databaseURL = lib.mkForce null;
        services.ncps.cache.databaseURLFile = builtins.toFile "db-url" "postgres://ncps:${lib.escapeURL postgresPassword}@postgres:5432/ncps?sslmode=disable";
      }
    ];
    ncps1 = ncpsAttrs "ncps1";

    postgres = {
      services.postgresql = {
        enable = true;
        enableTCPIP = true;
        authentication = ''
          host all all all scram-sha-256
        '';
        initialScript = pkgs.writeText "init-postgres.sql" ''
          CREATE DATABASE "ncps" WITH ENCODING = 'UTF8';
          CREATE ROLE "ncps" WITH LOGIN PASSWORD '${
            builtins.replaceStrings [ "'" ] [ "''" ] postgresPassword
          }';
          ALTER DATABASE "ncps" OWNER TO "ncps";
        '';
      };

      networking.firewall.allowedTCPPorts = [ 5432 ];
    };

    redis = {
      services.redis.servers.ncps = {
        enable = true;
        openFirewall = true;
        port = 6379;
        requirePass = redisPassword;
        bind = null;
      };
    };
  };

  testScript =
    { nodes, ... }:
    ''
      harmonia.start()
      garage.start()
      postgres.start()
      redis.start()

      garage.wait_for_unit("garage.service")
      garage.wait_for_open_port(3900)

      # Bootstrap a single-node Garage cluster with a fixed access key and bucket.
      garage_node_id = garage.succeed("garage status | tail -n1 | awk '{ print $1 }'").strip()
      garage.succeed(f"garage layout assign -c 1G -z garage {garage_node_id}")
      garage.succeed("garage layout apply --version 1")
      garage.succeed("garage key import ${garageAccessKey} ${garageSecretKey} --yes")
      garage.succeed("garage bucket create ${bucket}")
      garage.succeed("garage bucket allow --read --write ${bucket} --key ${garageAccessKey}")

      postgres.wait_for_unit("postgresql.service")
      redis.wait_for_unit("redis-ncps.service")

      redis.wait_until_succeeds("redis-cli -h redis -p 6379 -a '${redisPassword}' ping")

      start_all()

      harmonia.wait_for_unit("harmonia.socket")

      ncps0.wait_for_unit("ncps.service")
      ncps1.wait_for_unit("ncps.service")

      client0.wait_until_succeeds("curl -f http://ncps0:8501/ | grep '\"hostname\":\"${toString nodes.ncps0.services.ncps.cache.hostName}\"' >&2")
      client1.wait_until_succeeds("curl -f http://ncps1:8501/ | grep '\"hostname\":\"${toString nodes.ncps1.services.ncps.cache.hostName}\"' >&2")
    '';
}
