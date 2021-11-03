# This test ensures that the nixOS lxd images builds and functions properly
# It has been extracted from `lxd.nix` to seperate failures of just the image and the lxd software

import ./make-test-python.nix ({ pkgs, ...} : let
  release = import ../release.nix {
    /* configuration = {
      environment.systemPackages = with pkgs; [ stdenv ]; # inject stdenv so rebuild test works
    }; */
  };

  metadata = release.lxdMeta.${pkgs.system};
  image = release.lxdImage.${pkgs.system};

  lxd-config = pkgs.writeText "config.yaml" ''
    storage_pools:
      - name: default
        driver: dir
        config:
          source: /var/lxd-pool

    networks:
      - name: lxdbr0
        type: bridge
        config:
          ipv4.address: auto
          ipv6.address: none

    profiles:
      - name: default
        devices:
          eth0:
            name: eth0
            network: lxdbr0
            type: nic
          root:
            path: /
            pool: default
            type: disk
  '';
in {
  name = "lxd-image";

  meta = with pkgs.lib.maintainers; {
    maintainers = [ mkg20001 ];
  };

  machine = { lib, ... }: {
    virtualisation = {
      # OOMs otherwise
      memorySize = 1024;
      # disk full otherwise
      diskSize = 2048;

      lxc.lxcfs.enable = true;
      lxd.enable = true;
    };
  };

  testScript = ''
    machine.wait_for_unit("sockets.target")
    machine.wait_for_unit("lxd.service")
    machine.wait_for_file("/var/lib/lxd/unix.socket")

    # It takes additional second for lxd to settle
    machine.sleep(1)

    # lxd expects the pool's directory to already exist
    machine.succeed("mkdir /var/lxd-pool")

    machine.succeed(
        "cat ${lxd-config} | lxd init --preseed"
    )

    # TODO: test custom built container aswell

    with subtest("importing container works"):
        machine.succeed("lxc image import ${metadata}/*/*.tar.xz ${image}/*/*.tar.xz --alias nixos")

    with subtest("launching container works"):
        machine.succeed("lxc launch nixos machine -c security.nesting=true")
        # make sure machine boots up properly
        machine.sleep(5)

    with subtest("container shell works"):
        machine.succeed("echo true | lxc exec machine /run/current-system/sw/bin/bash -")
        machine.succeed("lxc exec machine /run/current-system/sw/bin/true")

    # with subtest("rebuilding works"):
    #     machine.succeed("lxc exec machine /run/current-system/sw/bin/nixos-rebuild switch")
  '';
})
