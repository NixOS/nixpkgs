import ./make-test-python.nix ({ lib, ... }:

with lib;

{
  name = "netbox";
  meta.maintainers = with maintainers; [ hexa ];

  nodes.machine = { pkgs, ... }: {
    networking.extraHosts = ''
      netbox.example.com ::1
    '';

    services.netbox = {
      enable = true;
      hostname = "netbox.example.com";
    };
  };

  testScript = ''
    machine.wait_for_unit("netbox.service")
    machine.wait_for_open_port("80")
    machine.succeed("curl --fail http://netbox.example.com/")
  '';
})
