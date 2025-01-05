{ pkgs, lib, ... }:

{
  name = "harmonia";

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

      # check that extra-allowed-users is effective for harmonia
      nix.settings.allowed-users = [ ];
    };

    client01 = {
      nix.settings = {
        substituters = lib.mkForce [ "http://harmonia:5000" ];
        trusted-public-keys = lib.mkForce [
          "cache.example.com-1:eIGQXcGQpc00x6/XFcyacLEUmC07u4RAEHt5Y8vdglo="
        ];
      };
    };
  };

  testScript =
    { nodes, ... }:
    ''
      start_all()

      harmonia.wait_for_unit("harmonia.service")

      client01.wait_until_succeeds("curl -f http://harmonia:5000/nix-cache-info | grep '${toString nodes.harmonia.services.harmonia.settings.priority}' >&2")
      client01.succeed("curl -f http://harmonia:5000/version | grep '${nodes.harmonia.services.harmonia.package.version}' >&2")

      client01.succeed("cat /etc/nix/nix.conf >&2")
      client01.succeed("nix-store --realise ${pkgs.emptyFile} --store /root/other-store")
    '';
}
