# Tests the contents attribute of nixos/lib/make-disk-image.nix
# including its user, group, and mode attributes.
{ system ? builtins.currentSystem,
  config ? {},
  pkgs ? import ../.. { inherit system config; }
}:

with import ../lib/testing-python.nix { inherit system pkgs; };
with pkgs.lib;

with import common/ec2.nix { inherit makeTest pkgs; };

let
  config = (import ../lib/eval-config.nix {
    inherit system;
    modules = [
      ../modules/testing/test-instrumentation.nix
      ../modules/profiles/qemu-guest.nix
      {
        fileSystems."/".device = "/dev/disk/by-label/test-nixos";
        boot.loader.grub.device = "/dev/vda";
        boot.loader.timeout = 0;
      }
    ];
  }).config;
  image = (import ../lib/make-disk-image.nix {
    inherit pkgs config;
    lib = pkgs.lib;
    format = "qcow2";
    partitionTableType = "hybrid";
    swapSize = 512;
    bootLabel = "test-boot";
    swapLabel = "test-swap";
    label = "test-nixos";
    contents = [{
      source = pkgs.writeText "testFile" "contents";
      target = "/testFile";
      user = "1234";
      group = "5678";
      mode = "755";
    }];
  }) + "/nixos.qcow2";

in makeEc2Test {
  name = "image-contents";
  inherit image;
  userData = null;
  script = ''
    machine.start()
    assert "content" in machine.succeed("cat /testFile")
    fileDetails = machine.succeed("ls -l /testFile")
    assert "1234" in fileDetails
    assert "5678" in fileDetails
    assert "rwxr-xr-x" in fileDetails

    # Make sure the disk labels are correct
    assert (
        machine.succeed("readlink -f /dev/disk/by-label/TEST-BOOT").strip() == "/dev/vda1"
    )
    assert (
        machine.succeed("readlink -f /dev/disk/by-partlabel/test-swap").strip()
        == "/dev/vda3"
    )
    assert (
        machine.succeed("readlink -f /dev/disk/by-label/test-nixos").strip() == "/dev/vda4"
    )

    # Turn the swap on
    machine.succeed("swapoff -a")
    machine.succeed("swapon /dev/disk/by-partlabel/test-swap")
    swapSize = machine.succeed("grep SwapTotal /proc/meminfo")
    assert "524284" in swapSize  # +4k header = 524288
  '';
}
