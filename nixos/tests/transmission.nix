import ./make-test.nix ({ pkgs, ...} : {
  name = "transmission";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ coconnor ];
  };

  machine = { ... }: {
    imports = [ ../modules/profiles/minimal.nix ];

    networking.firewall.allowedTCPPorts = [ 9091 ];

    services.transmission.enable = true;
  };

  testScript =
    ''
      startAll;
      $machine->waitForUnit("transmission");
      $machine->shutdown;
    '';
})
