import ./make-test-python.nix ({ pkgs, ...} :

let
  # Since we don't have access to the internet during the tests, we have to
  # pre-fetch lxd containers beforehand.
  #
  # I've chosen to import Alpine Linux, because its image is turbo-tiny and,
  # generally, sufficient for our tests.
  alpine-meta = pkgs.fetchurl {
    url = "https://tarballs.nixos.org/alpine/3.12/lxd.tar.xz";
    hash = "sha256-1tcKaO9lOkvqfmG/7FMbfAEToAuFy2YMewS8ysBKuLA=";
  };

  alpine-rootfs = pkgs.fetchurl {
    url = "https://tarballs.nixos.org/alpine/3.12/rootfs.tar.xz";
    hash = "sha256-Tba9sSoaiMtQLY45u7p5DMqXTSDgs/763L/SQp0bkCA=";
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
  name = "lxd-image-server";

  meta = with pkgs.lib.maintainers; {
    maintainers = [ mkg20001 ];
  };

  machine = { lib, ... }: {
    virtualisation = {
      cores = 2;

      memorySize = 2048;
      diskSize = 4096;

      lxc.lxcfs.enable = true;
      lxd.enable = true;
    };

    security.pki.certificates = [
      (builtins.readFile ./common/acme/server/ca.cert.pem)
    ];

    services.nginx = {
      enable = true;
    };

    services.lxd-image-server = {
      enable = true;
      nginx = {
        enable = true;
        domain = "acme.test";
      };
    };

    services.nginx.virtualHosts."acme.test" = {
      enableACME = false;
      sslCertificate = ./common/acme/server/acme.test.cert.pem;
      sslCertificateKey = ./common/acme/server/acme.test.key.pem;
    };

    networking.hosts = {
      "::1" = [ "acme.test" ];
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

    loc = "/var/www/simplestreams/images/iats/alpine/amd64/default/v1"

    with subtest("push image to server"):
        machine.succeed("lxc launch alpine test")
        machine.succeed("lxc stop test")
        machine.succeed("lxc publish --public test --alias=testimg")
        machine.succeed("lxc image export testimg")
        machine.succeed("ls >&2")
        machine.succeed("mkdir -p " + loc)
        machine.succeed("mv *.tar.gz " + loc)

    with subtest("pull image from server"):
        machine.succeed("lxc remote add img https://acme.test --protocol=simplestreams")
        machine.succeed("lxc image list img: >&2")
  '';
})
