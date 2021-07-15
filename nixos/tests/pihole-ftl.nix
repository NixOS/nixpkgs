import ./make-test-python.nix ({ lib, ... }:

  with lib;

  {
    name = "pihole-ftl";
    meta.maintainers = with maintainers; [ jamiemagee ];

    nodes.machine = { pkgs, ... }: { services.pihole-ftl.enable = true; };

    testScript = ''
      machine.start()
      machine.wait_for_unit("pihole-ftl.service")
      machine.wait_for_open_port(53)
      machine.wait_for_file("/etc/pihole/pihole-FTL.conf")
    '';
  })
