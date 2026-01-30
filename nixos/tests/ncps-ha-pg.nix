{
  lib,
  pkgs,
  ...
}:
let
  # s3 creds
  bucket = "ncps";
  region = "us-west-1";
  accessKey = builtins.toFile "minio-access-key" "easy-key";
  secretKey = builtins.toFile "minio-secret-key" "easy-secret";

  # pg creds
  postgresPassword = "easypwd";

  initMinio = pkgs.writeShellScriptBin "init-minio.sh" ''
    set -euo pipefail

    mc alias set local "http://127.0.0.1:9000" minioadmin minioadmin
    mc mb local/${bucket}
    mc admin user svcacct add --access-key "$(cat ${accessKey})" --secret-key "$(cat ${secretKey})" local minioadmin
  '';

  ncpsAttrs = hostname: {
    services.ncps = {
      enable = true;

      analytics.reporting.enable = false;

      cache = {
        hostName = hostname;

        databaseURL = "postgres://ncps:${lib.escapeURL postgresPassword}@postgres:5432/ncps?sslmode=disable";

        lock.backend = "postgres";

        secretKeyPath = builtins.toString (
          pkgs.writeText "ncps-cache-key" "ncps:dcrGsrku0KvltFhrR5lVIMqyloAdo0y8vYZOeIFUSLJS2IToL7dPHSSCk/fi+PJf8EorpBn8PU7MNhfvZoI8mA=="
        );

        storage.s3 = {
          inherit bucket region;

          endpoint = "http://minio:9000";

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

    minio = {
      services.minio = {
        inherit region;

        enable = true;
      };

      networking.firewall.allowedTCPPorts = [ 9000 ];
      environment.systemPackages = [
        pkgs.minio-client
        initMinio
      ];
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
  };

  testScript =
    { nodes, ... }:
    let
      narinfoName =
        (lib.strings.removePrefix "/nix/store/" (
          lib.strings.removeSuffix "-empty-file" pkgs.emptyFile.outPath
        ))
        + ".narinfo";

      narinfoNameChars = lib.strings.stringToCharacters narinfoName;

      narinfoPath = lib.concatStringsSep "/" [
        (builtins.head nodes.minio.services.minio.dataDir)
        bucket
        "store/narinfo"
        (lib.lists.elemAt narinfoNameChars 0)
        ((lib.lists.elemAt narinfoNameChars 0) + (lib.lists.elemAt narinfoNameChars 1))
        narinfoName
        "xl.meta"
      ];
    in
    ''
      harmonia.start()
      minio.start()
      postgres.start()

      minio.wait_for_unit("minio.service")

      minio.wait_until_succeeds("init-minio.sh")

      postgres.wait_for_unit("postgresql.service")

      start_all()

      harmonia.wait_for_unit("harmonia.service")

      ncps0.wait_for_unit("ncps.service")
      ncps1.wait_for_unit("ncps.service")

      client0.wait_until_succeeds("curl -f http://ncps0:8501/ | grep '\"hostname\":\"${toString nodes.ncps0.services.ncps.cache.hostName}\"' >&2")
      client1.wait_until_succeeds("curl -f http://ncps1:8501/ | grep '\"hostname\":\"${toString nodes.ncps1.services.ncps.cache.hostName}\"' >&2")

      client0.succeed("cat /etc/nix/nix.conf >&2")
      client0.succeed("nix-store --realise ${pkgs.emptyFile}")

      client1.succeed("cat /etc/nix/nix.conf >&2")
      client1.succeed("nix-store --realise ${pkgs.emptyFile}")

      minio.succeed("cat ${narinfoPath} >&2")
    '';
}
