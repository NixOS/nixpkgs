{ pkgs, lib, ... }:
{
  name = "multi-arch-test";
  meta.maintainers = with pkgs.lib.maintainers; [ tfc ];

  node.pkgsReadOnly = false;

  nodes = {
    # Setting build = host platform because such standard VM setups
    # are well-cached by the multi-arch build infrastructure of the
    # project.
    vmIntel = {
      nixpkgs.buildPlatform = "x86_64-linux";
      nixpkgs.hostPlatform = "x86_64-linux";
    };
    vmArm = {
      nixpkgs.buildPlatform = "aarch64-linux";
      nixpkgs.hostPlatform = "aarch64-linux";
    };
  };

  defaults = {
    # not needed for this test and shrinks the closure
    # because we dont' need qemu for all architectures
    virtualisation.qemu.guestAgent.enable = false;

    # the test is already very slow but we don't need DHCP anyway
    networking.dhcpcd.enable = false;

    # fix the network-online target, otherwise it doesn't work
    # properly as a synchronization mechanism.
    systemd.network.wait-online.enable = true;
    systemd.network.wait-online.anyInterface = true;
  };

  # slow due to SW emulation but shouldn't be slower than that
  globalTimeout = 5 * 60;

  testScript = { nodes, ... }: /* python */ ''
    start_all()

    vmIntel.systemctl("start network-online.target")
    vmArm.systemctl("start network-online.target")
    vmIntel.wait_for_unit("network-online.target")
    vmArm.wait_for_unit("network-online.target")

    vmIntel.succeed("ping -c 1 vmArm")
    vmArm.succeed("ping -c 1 vmIntel")

    archIntel = vmIntel.succeed("uname -m")
    t.assertIn("${nodes.vmIntel.nixpkgs.hostPlatform.qemuArch}", archIntel, "machine1 is an intel VM")
    archArm = vmArm.succeed("uname -m")
    t.assertIn("${nodes.vmArm.nixpkgs.hostPlatform.qemuArch}", archArm, "machine1 is an ARM VM")
  '';
}
