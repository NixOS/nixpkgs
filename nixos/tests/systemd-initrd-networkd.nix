import ./make-test-python.nix ({ pkgs, lib, ... }: {
  name = "systemd-initrd-network";
  meta.maintainers = [ lib.maintainers.elvishjerricco ];

  nodes = {
    basic = { ... }: {
      boot.initrd.network.enable = true;

      boot.initrd.systemd = {
        enable = true;
        network.networks."99-eth0" = {
          matchConfig.Name = "eth0";
          DHCP = "yes";
        };
        network.wait-online.timeout = 10;
        # Drop the boot into emergency mode if we timeout
        targets.network-online.requiredBy = [ "initrd.target" ];
        services.systemd-networkd-wait-online.requiredBy =
          [ "network-online.target" ];

          initrdBin = [ pkgs.iproute2 pkgs.iputils pkgs.gnugrep ];
          services.check = {
            requiredBy = [ "initrd.target" ];
            before = [ "initrd.target" ];
            after = [ "network-online.target" ];
            serviceConfig.Type = "oneshot";
            path = [ pkgs.iproute2 pkgs.iputils pkgs.gnugrep ];
            script = ''
              ip addr | grep 10.0.2.15 || exit 1
              ping -c1 10.0.2.2 || exit 1
            '';
          };
      };
    };
  };

  testScript = ''
    start_all()
    basic.wait_for_unit("multi-user.target")
    # Make sure the systemd-network user was set correctly in initrd
    basic.succeed("[ $(stat -c '%U,%G' /run/systemd/netif/links) = systemd-network,systemd-network ]")
    basic.succeed("ip addr show >&2")
    basic.succeed("ip route show >&2")
  '';
})
