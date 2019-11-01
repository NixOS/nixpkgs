import ../make-test.nix {
  name = "prosody";

  nodes = {
    client = { nodes, pkgs, ... }: {
      environment.systemPackages = [
        (pkgs.callPackage ./xmpp-sendmessage.nix { connectTo = nodes.server.config.networking.primaryIPAddress; })
      ];
    };
    server = { config, pkgs, ... }: {
      networking.extraHosts = ''
        ${config.networking.primaryIPAddress} example.com
      '';
      networking.firewall.enable = false;
      services.prosody = {
        enable = true;
        # TODO: use a self-signed certificate
        c2sRequireEncryption = false;
        extraConfig = ''
          storage = "sql"
        '';
        virtualHosts.test = {
          domain = "example.com";
          enabled = true;
        };
      };
    };
  };

  testScript = { nodes, ... }: ''
    $server->waitForUnit('prosody.service');
    $server->succeed('prosodyctl status') =~ /Prosody is running/;

    # set password to 'nothunter2' (it's asked twice)
    $server->succeed('yes nothunter2 | prosodyctl adduser cthon98@example.com');
    # set password to 'y'
    $server->succeed('yes | prosodyctl adduser azurediamond@example.com');
    # correct password to 'hunter2'
    $server->succeed('yes hunter2 | prosodyctl passwd azurediamond@example.com');

    $client->succeed("send-message");

    $server->succeed('prosodyctl deluser cthon98@example.com');
    $server->succeed('prosodyctl deluser azurediamond@example.com');
  '';
}
