import ./make-test-python.nix ({ pkgs, ... }: {
  name = "libvirtd";
  meta.maintainers = with pkgs.lib.maintainers; [ fpletz ];

  nodes = {
    virthost =
      { pkgs, ... }:
      {
        virtualisation = {
          cores = 2;
          memorySize = 2048;

          libvirtd.enable = true;
        };
        networking.nameservers = [ "192.168.122.1" ];
        security.polkit.enable = true;
        environment.systemPackages = with pkgs; [ virt-manager ];
      };
  };

  testScript = let
    nixosInstallISO = (import ../release.nix {}).iso_minimal.${pkgs.hostPlatform.system};
    virshShutdownCmd = if pkgs.stdenv.isx86_64 then "shutdown" else "destroy";
  in ''
    start_all()

    virthost.wait_for_unit("sockets.target")

    with subtest("enable default network"):
      virthost.succeed("virsh net-start default")
      virthost.succeed("virsh net-autostart default")
      virthost.succeed("virsh net-info default")

    with subtest("check if partition disk pools works with parted"):
      virthost.succeed("fallocate -l100m /tmp/foo; losetup /dev/loop0 /tmp/foo; echo 'label: dos' | sfdisk /dev/loop0")
      virthost.succeed("virsh pool-create-as foo disk --source-dev /dev/loop0 --target /dev")
      virthost.succeed("virsh vol-create-as foo loop0p1 25MB")
      virthost.succeed("virsh vol-create-as foo loop0p2 50MB")

    with subtest("check if nixos install iso boots and network works"):
      virthost.succeed(
        "virt-install -n nixos --osinfo=nixos-unstable --ram=1024 --graphics=none --disk=`find ${nixosInstallISO}/iso -type f | head -n1`,readonly=on --import --noautoconsole"
      )
      virthost.succeed("virsh domstate nixos | grep running")
      virthost.wait_until_succeeds("ping -c 1 nixos")
      virthost.succeed("virsh ${virshShutdownCmd} nixos")
      virthost.wait_until_succeeds("virsh domstate nixos | grep 'shut off'")
  '';
})
