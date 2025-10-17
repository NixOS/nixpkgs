{ pkgs, lib, ... }:

let
  incus-image = import ../release.nix {
    configuration = {
      # Building documentation makes the test unnecessarily take a longer time:
      documentation.enable = lib.mkForce false;
    };
  };

  incus-image-metadata =
    incus-image.incusContainerMeta.${pkgs.stdenv.hostPlatform.system}
    + "/tarball/nixos-image-lxc-*-${pkgs.stdenv.hostPlatform.system}.tar.xz";

  incus-image-rootfs =
    incus-image.incusContainerImage.${pkgs.stdenv.hostPlatform.system}
    + "/nixos-lxc-image-${pkgs.stdenv.hostPlatform.system}.squashfs";

in
{
  name = "lxd-image-server";

  meta = with pkgs.lib.maintainers; {
    maintainers = [
      mkg20001
      patryk27
    ];
  };

  nodes.machine =
    { lib, ... }:
    {
      virtualisation = {
        cores = 2;

        memorySize = 2048;
        diskSize = 4096;

        incus.enable = true;
      };

      # incus requires
      networking.nftables.enable = true;

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
    machine.wait_for_unit("incus.service")

    machine.succeed("incus admin waitready")
    machine.succeed("incus admin init --minimal")

    machine.succeed(
        "incus image import ${incus-image-metadata} ${incus-image-rootfs} --alias nixos"
    )

    loc = "/var/www/simplestreams/images/iats/nixos/amd64/default/v1"

    with subtest("push image to server"):
        machine.succeed("incus launch nixos test")
        machine.sleep(5)
        machine.succeed("incus stop -f test")
        machine.succeed("incus publish --public test --alias=testimg")
        machine.succeed("incus image export testimg")
        machine.succeed("ls >&2")
        machine.succeed("mkdir -p " + loc)
        machine.succeed("mv *.tar.gz " + loc)

    with subtest("pull image from server"):
        machine.succeed("incus remote add img https://acme.test --protocol=simplestreams")
        machine.succeed("incus image list img: >&2")
  '';
}
