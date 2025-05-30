{
  lib,
  pkgs,
  ...
}:

{
  name = "ncps";

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

        cache = {
          hostName = "ncps";
          secretKeyPath = builtins.toString (
            pkgs.writeText "ncps-cache-key" "ncps:dcrGsrku0KvltFhrR5lVIMqyloAdo0y8vYZOeIFUSLJS2IToL7dPHSSCk/fi+PJf8EorpBn8PU7MNhfvZoI8mA=="
          );
        };

        upstream = {
          caches = [ "http://harmonia:5000" ];
          publicKeys = [
            "cache.example.com-1:eIGQXcGQpc00x6/XFcyacLEUmC07u4RAEHt5Y8vdglo="
          ];
        };
      };

      networking.firewall.allowedTCPPorts = [ 8501 ];
    };

    client01 = {
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
        nodes.ncps.services.ncps.cache.dataPath
        "store/narinfo"
        (lib.lists.elemAt narinfoNameChars 0)
        ((lib.lists.elemAt narinfoNameChars 0) + (lib.lists.elemAt narinfoNameChars 1))
        narinfoName
      ];
    in
    ''
      start_all()

      harmonia.wait_for_unit("harmonia.service")

      ncps.wait_for_unit("ncps.service")

      client01.wait_until_succeeds("curl -f http://ncps:8501/ | grep '\"hostname\":\"${toString nodes.ncps.services.ncps.cache.hostName}\"' >&2")

      client01.succeed("cat /etc/nix/nix.conf >&2")
      client01.succeed("nix-store --realise ${pkgs.emptyFile}")

      ncps.succeed("cat ${narinfoPath} >&2")
    '';
}
