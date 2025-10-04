{
  name = "ifstate-dhcp";

  defaults = {
    imports = [ ../../modules/profiles/minimal.nix ];

    virtualisation.interfaces.eth1.vlan = 1;
  };

  nodes = {
    router =
      { lib, ... }:
      {
        networking.interfaces.eth1 = {
          ipv4.addresses = lib.mkForce [
            {
              address = "192.0.2.1";
              prefixLength = 24;
            }
          ];
          ipv6.addresses = lib.mkForce [ ];
        };
        services.kea.dhcp4 = {
          enable = true;
          settings = {
            interfaces-config.interfaces = [ "eth1" ];
            subnet4 = [
              {
                id = 1;
                subnet = "192.0.2.0/24";
                pools = [
                  {
                    pool = "192.0.2.100-192.0.2.199";
                  }
                ];
                option-data = [
                  {
                    name = "routers";
                    data = "192.0.2.1";
                  }
                ];
              }
            ];
          };
        };
      };
    client =
      { lib, pkgs, ... }:
      {
        networking.ifstate = {
          enable = true;
          settings = {
            parameters.hooks.dhcp.script = pkgs.writeScript "ifstate-udhcp-wrapper-script.sh" ''
              ${lib.getExe' pkgs.busybox "udhcpc"} --quit --now -i $IFS_IFNAME -b --script ${pkgs.busybox}/default.script
            '';
            interfaces.eth1 = {
              addresses = [ ];
              hooks = [
                {
                  name = "dhcp";
                }
              ];
              link = {
                state = "up";
                kind = "physical";
              };
            };
          };
        };
      };
  };

  testScript = # python
    ''
      start_all()

      router.wait_for_unit("default.target")
      client.wait_for_unit("default.target")

      client.wait_until_succeeds("ping -c 1 192.0.2.1")
    '';
}
