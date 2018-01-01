import ./make-test.nix {
  name = "unified-remote";

  nodes = {
    server = { pkgs, ... }:
    {
      networking.firewall.enable = true;
      nixpkgs.config.allowUnfree = true;
      services.unified-remote.enable = true;
      services.unified-remote.openFirewall = true;
    };
    client = { pkgs, ... }:
    {
    };
  };

  testScript = { nodes, ... }:
    let cfg = nodes.server.config.services.unified-remote;
        inherit (builtins) toString;
    in
    ''
      $server->waitForUnit('network-online.target');
      $server->waitForUnit('unified-remote.service');
      $client->waitForUnit('multi-user.target');
      $server->waitForUnit('network-online.target');
      $client->succeed('nc -w 1 -z server ${toString cfg.remotesPort}');
      $client->succeed('nc -w 1 -z -u server ${toString cfg.remotesPort}');
      $client->succeed('nc -w 1 -z server ${toString cfg.webPort}');
      $client->succeed('nc -w 1 -z -u server ${toString cfg.discoveryPort}');
      $client->succeed('curl --connect-timeout 1 http://server:${toString cfg.webPort}/web');
    '';
}
