import ./make-test-python.nix ({ pkgs, ... }:
{
  name = "harmonia";
  nodes = {
    harmonia = {
      services.harmonia = {
        enable = true;
        signKeyPath = pkgs.writeText "cache-key"
          "cache.example.com-1:9FhO0w+7HjZrhvmzT1VlAZw4OSAlFGTgC24Seg3tmPl4gZBdwZClzTTHr9cVzJpwsRSYLTu7hEAQe3ljy92CWg==";
      };

      networking.firewall.allowedTCPPorts = [ 5000 ];
      system.extraDependencies = [ pkgs.hello ];
    };

    client01 = { lib, ... }: {
      nix.settings = {
        substituters = lib.mkForce [ "http://harmonia:5000" ];
        trusted-public-keys = lib.mkForce [ "cache.example.com-1:eIGQXcGQpc00x6/XFcyacLEUmC07u4RAEHt5Y8vdglo=" ];
      };
    };
  };

  testScript = ''
    start_all()

    client01.wait_until_succeeds("curl -f http://harmonia:5000/version")
    client01.succeed("curl -f http://harmonia:5000/nix-cache-info")

    client01.succeed("cat /etc/nix/nix.conf >&2")
    client01.wait_until_succeeds("nix-store --realise ${pkgs.hello} --store /root/other-store")
  '';
})
