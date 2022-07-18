import ./make-test-python.nix ({ pkgs, lib, ... } :

let
  lxd-image = import ../release.nix {
    configuration = {
      # Building documentation makes the test unnecessarily take a longer time:
      documentation.enable = lib.mkForce false;
    };
  };

  lxd-image-metadata = lxd-image.lxdMeta.${pkgs.system};
  lxd-image-rootfs = lxd-image.lxdImage.${pkgs.system};

in {
  name = "lxd-image-server";

  meta = with pkgs.lib.maintainers; {
    maintainers = [ mkg20001 patryk27 ];
  };

  nodes.machine = { lib, ... }: {
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
        "cat ${./common/lxd/config.yaml} | lxd init --preseed"
    )

    machine.succeed(
        "lxc image import ${lxd-image-metadata}/*/*.tar.xz ${lxd-image-rootfs}/*/*.tar.xz --alias nixos"
    )

    loc = "/var/www/simplestreams/images/iats/nixos/amd64/default/v1"

    with subtest("push image to server"):
        machine.succeed("lxc launch nixos test")
        machine.sleep(5)
        machine.succeed("lxc stop -f test")
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
