import ./make-test-python.nix ({ lib, pkgs, ...} : {
  name = "fakeroute";
  meta.maintainers = with lib.maintainers; [ rnhmjoj ];

  nodes.machine = { ... }: {
    imports = [ ../modules/profiles/minimal.nix ];
    services.fakeroute.enable = true;
    services.fakeroute.route =
      [ "216.102.187.130" "4.0.1.122"
        "198.116.142.34" "63.199.8.242"
      ];
    environment.systemPackages = [ pkgs.traceroute ];
  };

  testScript =
    ''
      start_all()
      machine.wait_for_unit("fakeroute.service")
      machine.succeed("traceroute 127.0.0.1 | grep -q 216.102.187.130")
    '';
})

