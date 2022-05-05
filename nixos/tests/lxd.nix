import ./make-test-python.nix ({ pkgs, ...} :

let
  # Since we don't have access to the internet during the tests, we have to
  # pre-fetch lxd containers beforehand.
  #
  # I've chosen to import Alpine Linux, because its image is turbo-tiny and,
  # generally, sufficient for our tests.
  alpine-meta-x86 = pkgs.fetchurl {
    url = "https://tarballs.nixos.org/alpine/3.12/lxd.tar.xz";
    hash = "sha256-1tcKaO9lOkvqfmG/7FMbfAEToAuFy2YMewS8ysBKuLA=";
  };
  alpine-meta-for = arch: pkgs.stdenv.mkDerivation {
    name = "alpine-meta-${arch}";
    version = "3.12";
    unpackPhase = "true";
    buildPhase = ''
      runHook preBuild

      tar xvf ${alpine-meta-x86}
      sed -i 's/architecture: .*/architecture: ${arch}/' metadata.yaml

      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall

      tar czRf $out *

      runHook postInstall
    '';
  };

  alpine-meta = {
    x86_64-linux = alpine-meta-x86;
    aarch64-linux = alpine-meta-for "aarch64";
  }.${pkgs.system} or (throw "Unsupported system: ${pkgs.system}");

  alpine-rootfs = {
    x86_64-linux = pkgs.fetchurl {
      url = "https://tarballs.nixos.org/alpine/3.12/rootfs.tar.xz";
      hash = "sha256-Tba9sSoaiMtQLY45u7p5DMqXTSDgs/763L/SQp0bkCA=";
    };
    aarch64-linux = pkgs.fetchurl {
      url = "https://dl-cdn.alpinelinux.org/alpine/v3.15/releases/aarch64/alpine-minirootfs-3.15.4-aarch64.tar.gz";
      hash = "sha256-9kBz8Jwmo8XepJhTMt5zilCaHHpflnUH7y9+0To39Us=";
    };
  }.${pkgs.system} or (throw "Unsupported system: ${pkgs.system}");

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

  meta = with pkgs.lib.maintainers; {
    maintainers = [ patryk27 ];
  };

  nodes.machine = { lib, ... }: {
    virtualisation = {
      # Since we're testing `limits.cpu`, we've gotta have a known number of
      # cores to lean on
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
    machine.wait_for_file("/var/lib/lxd/unix.socket")

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
        machine.succeed("lxc restart test")

        # Since Alpine doesn't have `nproc` pre-installed, we've gotta resort
        # to the primal methods
        assert (
            "1"
            == machine.succeed("lxc exec test grep -- -c ^processor /proc/cpuinfo").strip()
        )

        machine.succeed("lxc config set test limits.cpu 2")
        machine.succeed("lxc restart test")

        assert (
            "2"
            == machine.succeed("lxc exec test grep -- -c ^processor /proc/cpuinfo").strip()
        )

        ## ------------- ##
        ## limits.memory ##

        machine.succeed("lxc config set test limits.memory 64MB")
        machine.succeed("lxc restart test")

        assert (
            "MemTotal:          62500 kB"
            == machine.succeed("lxc exec test grep -- MemTotal /proc/meminfo").strip()
        )

        machine.succeed("lxc config set test limits.memory 128MB")
        machine.succeed("lxc restart test")

        assert (
            "MemTotal:         125000 kB"
            == machine.succeed("lxc exec test grep -- MemTotal /proc/meminfo").strip()
        )

        machine.succeed("lxc delete -f test")
  '';
})
