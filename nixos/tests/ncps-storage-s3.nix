{
  lib,
  pkgs,
  ...
}:
let
  bucket = "ncps";
  region = "us-west-1";
  accessKey = "test-access-key";
  secretKey = "test-secret-key";

  initMinio = pkgs.writeShellScriptBin "init-minio.sh" ''
    set -euo pipefail

    mc alias set local "http://127.0.0.1:9000" minioadmin minioadmin
    mc mb local/${bucket}
    mc admin user svcacct add --access-key ${accessKey} --secret-key ${secretKey} local minioadmin
  '';
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

    ncps = {
      services.ncps = {
        enable = true;

        analytics.reporting.enable = false;

        cache = {
          hostName = "ncps";

          secretKeyPath = builtins.toString (
            pkgs.writeText "ncps-cache-key" "ncps:dcrGsrku0KvltFhrR5lVIMqyloAdo0y8vYZOeIFUSLJS2IToL7dPHSSCk/fi+PJf8EorpBn8PU7MNhfvZoI8mA=="
          );

          storage.s3 = {
            inherit bucket region;

            endpoint = "http://minio:9000";

            accessKeyIdPath = builtins.toFile "minio-access-key" accessKey;
            secretAccessKeyPath = builtins.toFile "minio-secret-key" secretKey;
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

    client = {
      nix.settings = {
        substituters = lib.mkForce [ "http://ncps:8501" ];
        trusted-public-keys = lib.mkForce [
          "ncps:UtiE6C+3Tx0kgpP34vjyX/BKK6QZ/D1OzDYX72aCPJg="
        ];
      };
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
      minio.start()

      minio.wait_for_unit("minio.service")

      minio.wait_until_succeeds("init-minio.sh")

      start_all()

      harmonia.wait_for_unit("harmonia.service")

      ncps.wait_for_unit("ncps.service")

      client.wait_until_succeeds("curl -f http://ncps:8501/ | grep '\"hostname\":\"${toString nodes.ncps.services.ncps.cache.hostName}\"' >&2")

      client.succeed("cat /etc/nix/nix.conf >&2")
      client.succeed("nix-store --realise ${pkgs.emptyFile}")

      minio.succeed("cat ${narinfoPath} >&2")
    '';
}
