import ../make-test-python.nix (

  { pkgs, lib, ... }:

  let
    releases = import ../../release.nix { configuration.documentation.enable = lib.mkForce false; };

    container-image-metadata = releases.lxdContainerMeta.${pkgs.stdenv.hostPlatform.system};
    container-image-rootfs = releases.lxdContainerImage.${pkgs.stdenv.hostPlatform.system};
  in
  {
    name = "lxd-to-incus";

    meta = {
      maintainers = lib.teams.lxc.members;
    };

    nodes.machine =
      { lib, ... }:
      {
        environment.systemPackages = [ pkgs.lxd-to-incus ];

        virtualisation = {
          diskSize = 6144;
          cores = 2;
          memorySize = 2048;

          lxd.enable = true;
          lxd.preseed = {
            networks = [
              {
                name = "nixostestbr0";
                type = "bridge";
                config = {
                  "ipv4.address" = "10.0.100.1/24";
                  "ipv4.nat" = "true";
                };
              }
            ];
            profiles = [
              {
                name = "default";
                devices = {
                  eth0 = {
                    name = "eth0";
                    network = "nixostestbr0";
                    type = "nic";
                  };
                  root = {
                    path = "/";
                    pool = "nixostest_pool";
                    size = "35GiB";
                    type = "disk";
                  };
                };
              }
              {
                name = "nixos_notdefault";
                devices = { };
              }
            ];
            storage_pools = [
              {
                name = "nixostest_pool";
                driver = "dir";
              }
            ];
          };

          incus.enable = true;
        };
      };

    testScript = ''
      def lxd_wait_for_preseed(_) -> bool:
        _, output = machine.systemctl("is-active lxd-preseed.service")
        return ("inactive" in output)

      def lxd_instance_is_up(_) -> bool:
          status, _ = machine.execute("lxc exec container --disable-stdin --force-interactive /run/current-system/sw/bin/true")
          return status == 0

      def incus_instance_is_up(_) -> bool:
          status, _ = machine.execute("incus exec container --disable-stdin --force-interactive /run/current-system/sw/bin/true")
          return status == 0

      with machine.nested("initialize lxd and resources"):
        machine.wait_for_unit("sockets.target")
        machine.wait_for_unit("lxd.service")
        retry(lxd_wait_for_preseed)

        machine.succeed("lxc image import ${container-image-metadata}/*/*.tar.xz ${container-image-rootfs}/*/*.tar.xz --alias nixos")
        machine.succeed("lxc launch nixos container")
        retry(lxd_instance_is_up)

      machine.wait_for_unit("incus.service")

      with machine.nested("run migration"):
          machine.succeed("lxd-to-incus --yes")

      with machine.nested("verify resources migrated to incus"):
          machine.succeed("incus config show container")
          retry(incus_instance_is_up)
          machine.succeed("incus exec container -- true")
          machine.succeed("incus profile show default | grep nixostestbr0")
          machine.succeed("incus profile show default | grep nixostest_pool")
          machine.succeed("incus profile show nixos_notdefault")
          machine.succeed("incus storage show nixostest_pool")
          machine.succeed("incus network show nixostestbr0")
    '';
  }
)
