import ./make-test.nix ({ pkgs, ...} : {
  name = "magnetico";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ rnhmjoj ];
  };

  machine = { ... }: {
    imports = [ ../modules/profiles/minimal.nix ];

    networking.firewall.allowedTCPPorts = [ 9000 ];

    services.magnetico = {
      enable = true;
      crawler.port = 9000;
      web.credentials.user = "$2y$12$P88ZF6soFthiiAeXnz64aOWDsY3Dw7Yw8fZ6GtiqFNjknD70zDmNe";
    };
  };

  testScript =
    ''
      startAll;
      $machine->waitForUnit("magneticod");
      $machine->waitForUnit("magneticow");
      $machine->succeed("${pkgs.curl}/bin/curl -u user:password http://localhost:8080");
      $machine->succeed("${pkgs.curl}/bin/curl -u user:wrongpwd http://localhost:8080") =~ "Unauthorised." or die;
      $machine->shutdown();
    '';
})
