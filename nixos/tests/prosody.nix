import ./make-test.nix {
  name = "prosody";

  machine = { pkgs, ... }: {
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
    environment.systemPackages = [
      (pkgs.callPackage ./xmpp-sendmessage.nix {})
    ];
  };

  testScript = ''
    $machine->waitForUnit('prosody.service');
    $machine->succeed('prosodyctl status') =~ /Prosody is running/;

    # set password to 'nothunter2' (it's asked twice)
    $machine->succeed('yes nothunter2 | prosodyctl adduser cthon98@example.com');
    # set password to 'y'
    $machine->succeed('yes | prosodyctl adduser azurediamond@example.com');
    # correct password to 'hunter2'
    $machine->succeed('yes hunter2 | prosodyctl passwd azurediamond@example.com');

    $machine->succeed("send-message");

    $machine->succeed('prosodyctl deluser cthon98@example.com');
    $machine->succeed('prosodyctl deluser azurediamond@example.com');
  '';
}
