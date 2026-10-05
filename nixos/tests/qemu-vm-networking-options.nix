{ lib, ... }:
{
  name = "qemu-vm-networking-options";
  meta.maintainers = [ lib.maintainers.marie ];

  nodes = {
    none =
      { pkgs, ... }:
      {
        virtualisation = {
          qemu.networkingOptions = [ "-nic none" ];
          interfaces = { };
          vlans = [ ];
        };
        environment.systemPackages = [ pkgs.iproute2 ];
      };
  };

  testScript = ''
    import json

    none.start()
    links = json.loads(none.succeed("ip --json link"))
    t.assertEqual(len(links), 1, f"Machine has more than one network interface: {links}")
  '';
}
