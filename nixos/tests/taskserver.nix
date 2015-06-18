import ./make-test.nix {
  name = "taskserver";

  nodes = {
    server = { config, pkgs, ... }: {
      services.taskserver.enable = true;
      networking.firewall.allowedTCPPorts = [ config.services.taskserver.server.port ];
    };

    client = { config, pkgs, ... }: {
      environment.systemPackages = [ pkgs.taskwarrior ];
    };

  };

  testScript = ''
    startAll;

    $server->waitForUnit("taskserver.service");
    $client->waitForUnit("multi-user.target");
  '';

}
