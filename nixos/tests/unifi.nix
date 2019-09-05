import ./make-test.nix ({ pkgs, ... }:

let
  httpPort = 8080;
  httpsPort = 18443;

in rec {
  name = "unifi";

  meta = with pkgs.stdenv.lib; {
    maintainers = with maintainers; [ peterhoeg ];
  };

  nodes = {
    server = { pkgs, ... }: {
      boot.kernelPackages = kernel;
      services.unifi = {
        enable = true;
        openPorts = true;
        unifiPackage = pkgs.unifiStable;
        inherit httpPort httpsPort;
      };
      nixpkgs.config.allowUnfree = true;
    };

    client = { pkgs, ... }: {
      environment.systemPackages = with pkgs; [ curl ];
    };
  };

  testScript = ''
    startAll;

    $server->waitForOpenPort(${toString httpPort});

    $server->waitUntilSucceeds("test -d /var/lib/unifi/data");
    $server->waitUntilSucceeds("test -d /var/lib/unifi/logs");
    $server->waitUntilSucceeds("test -d /var/lib/unifi/run");

    $server->waitUntilSucceeds("test -L /var/lib/unifi/webapps/ROOT");
    $server->waitUntilSucceeds("test -f /var/lib/unifi/data/system.properties");

    $client->waitUntilSucceeds("curl --insecure --silent https://server:${toString httpsPort}");
  '';
})
