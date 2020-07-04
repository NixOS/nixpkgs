import ./make-test-python.nix ({ pkgs, ...} :

let
  # Since we don't have access to the internet during the tests, we have to
  # pre-fetch lxd containers beforehand.
  #
  # I've chosen to import Alpine Linux, because its image is turbo-tiny and,
  # generally, sufficient for our tests.

  alpine-meta = pkgs.fetchurl {
    url = "https://uk.images.linuxcontainers.org/images/alpine/3.11/i386/default/20200608_13:00/lxd.tar.xz";
    sha256 = "1hkvaj3rr333zmx1759njy435lps33gl4ks8zfm7m4nqvipm26a0";
  };

  alpine-rootfs = pkgs.fetchurl {
    url = "https://uk.images.linuxcontainers.org/images/alpine/3.11/i386/default/20200608_13:00/rootfs.tar.xz";
    sha256 = "1v82zdra4j5xwsff09qlp7h5vbsg54s0j7rdg4rynichfid3r347";
  };

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
  name = "lxd";
  meta = with pkgs.stdenv.lib.maintainers; {
    maintainers = [ patryk27 ];
  };

  machine = { lib, ... }: {
    virtualisation = {
      # Since we're testing `limits.cpu`, we've gotta have a known number of
      # cores to lay on
      cores = 2;

      # Ditto, for `limits.memory`
      memorySize = 512;

      lxc.lxcfs.enable = true;
      lxd.enable = true;
    };
  };

  testScript = ''
    machine.wait_for_unit("sockets.target")
    machine.wait_for_unit("lxd.service")

    # It takes additional second for lxd to settle
    machine.sleep(1)

    # lxd expects the pool's directory to already exist
    machine.succeed("mkdir /var/lxd-pool")

    machine.succeed(
        "cat ${lxd-config} | lxd init --preseed"
    )

    machine.succeed(
        "lxc image import ${alpine-meta} ${alpine-rootfs} --alias alpine"
    )

    with subtest("Containers can be launched and destroyed"):
        machine.succeed("lxc launch alpine test")
        machine.succeed("lxc exec test true")
        machine.succeed("lxc delete -f test")

    with subtest("Containers are being mounted with lxcfs inside"):
        machine.succeed("lxc launch alpine test")

        ## ---------- ##
        ## limits.cpu ##

        machine.succeed("lxc config set test limits.cpu 1")

        # Since Alpine doesn't have `nproc` pre-installed, we've gotta resort
        # to the primal methods
        assert (
            "1"
            == machine.succeed("lxc exec test grep -- -c ^processor /proc/cpuinfo").strip()
        )

        machine.succeed("lxc config set test limits.cpu 2")

        assert (
            "2"
            == machine.succeed("lxc exec test grep -- -c ^processor /proc/cpuinfo").strip()
        )

        ## ------------- ##
        ## limits.memory ##

        machine.succeed("lxc config set test limits.memory 64MB")

        assert (
            "MemTotal:          62500 kB"
            == machine.succeed("lxc exec test grep -- MemTotal /proc/meminfo").strip()
        )

        machine.succeed("lxc config set test limits.memory 128MB")

        assert (
            "MemTotal:         125000 kB"
            == machine.succeed("lxc exec test grep -- MemTotal /proc/meminfo").strip()
        )

        machine.succeed("lxc delete -f test")

    with subtest("Unless explicitly changed, lxd leans on iptables"):
        machine.succeed("lsmod | grep ip_tables")
        machine.fail("lsmod | grep nf_tables")
  '';
})
