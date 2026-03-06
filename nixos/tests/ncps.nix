{
  lib,
  pkgs,
  ...
}:

{
  name = "ncps";
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

    ncps = {
      services.ncps = {
        enable = true;

        analytics.reporting.enable = false;

        cache = {
          hostName = "ncps";
          secretKeyPath = toString (
            pkgs.writeText "ncps-cache-key" "ncps:dcrGsrku0KvltFhrR5lVIMqyloAdo0y8vYZOeIFUSLJS2IToL7dPHSSCk/fi+PJf8EorpBn8PU7MNhfvZoI8mA=="
          );

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
    ''
      start_all()

      harmonia.wait_for_unit("harmonia.service")

      ncps.wait_for_unit("ncps.service")

      client.wait_until_succeeds("curl -f http://ncps:8501/ | grep '\"hostname\":\"${toString nodes.ncps.services.ncps.cache.hostName}\"' >&2")

      client.succeed("cat /etc/nix/nix.conf >&2")
      client.succeed("nix-store --realise ${pkgs.emptyFile}")

      # Verify that the NAR file exists in the cache storage
      # We query the NAR hash from the client and then check if a file with that hash exists in the ncps storage
      nar_hash = client.succeed("nix-store -q --hash ${pkgs.emptyFile}").strip().split(":")[1]
      ncps.succeed(f"find ${nodes.ncps.services.ncps.cache.storage.local} -type f | grep {nar_hash}")
    '';
}
