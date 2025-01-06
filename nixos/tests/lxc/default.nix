import ../make-test-python.nix (
  { pkgs, lib, ... }:

  let
    releases = import ../../release.nix {
      configuration = {
        # Building documentation makes the test unnecessarily take a longer time:
        documentation.enable = lib.mkForce false;
      };
    };

    lxc-image-metadata = releases.lxdContainerMeta.${pkgs.stdenv.hostPlatform.system};
    lxc-image-rootfs = releases.lxdContainerImage.${pkgs.stdenv.hostPlatform.system};

  in
  {
    name = "lxc-container-unprivileged";

    meta = {
      maintainers = lib.teams.lxc.members;
    };

    nodes.machine =
      { lib, pkgs, ... }:
      {
        virtualisation = {
          diskSize = 6144;
          cores = 2;
          memorySize = 512;
          writableStore = true;

          lxc = {
            enable = true;
            unprivilegedContainers = true;
            systemConfig = ''
              lxc.lxcpath = /tmp/lxc
            '';
            defaultConfig = ''
              lxc.net.0.type = veth
              lxc.net.0.link = lxcbr0
              lxc.net.0.flags = up
              lxc.net.0.hwaddr = 00:16:3e:xx:xx:xx
              lxc.idmap = u 0 100000 65536
              lxc.idmap = g 0 100000 65536
            '';
            # Permit user alice to connect to bridge
            usernetConfig = ''
              @lxc-user veth lxcbr0 10
            '';
            bridgeConfig = ''
              LXC_IPV6_ADDR=""
              LXC_IPV6_MASK=""
              LXC_IPV6_NETWORK=""
              LXC_IPV6_NAT="false"
            '';
          };
        };

        # Needed for lxc
        environment.systemPackages = with pkgs; [
          pkgs.wget
          pkgs.dnsmasq
        ];

        # Create user for test
        users.users.alice = {
          isNormalUser = true;
          password = "test";
          description = "Lxc unprivileged user with access to lxcbr0";
          extraGroups = [ "lxc-user" ];
          subGidRanges = [
            {
              startGid = 100000;
              count = 65536;
            }
          ];
          subUidRanges = [
            {
              startUid = 100000;
              count = 65536;
            }
          ];
        };

        users.users.bob = {
          isNormalUser = true;
          password = "test";
          description = "Lxc unprivileged user without access to lxcbr0";
          subGidRanges = [
            {
              startGid = 100000;
              count = 65536;
            }
          ];
          subUidRanges = [
            {
              startUid = 100000;
              count = 65536;
            }
          ];
        };
      };

    testScript = ''
      machine.wait_for_unit("lxc-net.service")

      # Copy config files for alice
      machine.execute("su -- alice -c 'mkdir -p ~/.config/lxc'")
      machine.execute("su -- alice -c 'cp /etc/lxc/default.conf ~/.config/lxc/'")
      machine.execute("su -- alice -c 'cp /etc/lxc/lxc.conf ~/.config/lxc/'")

      machine.succeed("su -- alice -c 'lxc-create -t local -n test -- --metadata ${lxc-image-metadata}/*/*.tar.xz --fstree ${lxc-image-rootfs}/*/*.tar.xz'")
      machine.succeed("su -- alice -c 'lxc-start test'")
      machine.succeed("su -- alice -c 'lxc-stop test'")

      # Copy config files for bob
      machine.execute("su -- bob -c 'mkdir -p ~/.config/lxc'")
      machine.execute("su -- bob -c 'cp /etc/lxc/default.conf ~/.config/lxc/'")
      machine.execute("su -- bob -c 'cp /etc/lxc/lxc.conf ~/.config/lxc/'")

      machine.fail("su -- bob -c 'lxc-start test'")
    '';
  }
)
