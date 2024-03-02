import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "peroxide";
  meta.maintainers = with lib.maintainers; [ aidalgol ];

  nodes.machine =
    { config, pkgs, ... }: {
      networking.hostName = "nixos";
      services.peroxide.enable = true;
    };

  testScript = ''
    machine.wait_for_unit("peroxide.service")
    machine.wait_for_open_port(1143) # IMAP
    machine.wait_for_open_port(1025) # SMTP
  '';
})
